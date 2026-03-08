#!/usr/bin/env python3
"""
Diun Webhook Receiver + Prometheus Exporter
Receives Diun webhook payloads and exposes metrics at /metrics.
Uses only Python standard library.

State is persisted to the "state.json" file inside DIUN_EXPORTER_DATA_PATH.
Entries older than DIUN_EXPORTER_TTL_SECONDS are evicted on each scrape and on startup.

Endpoints:
  POST /webhook  - receive Diun notifications
  GET  /metrics  - Prometheus exposition format
  GET  /healthz  - liveness probe
  GET  /readyz   - readiness probe
  POST /clear    - remove all entries (call after upgrading images)
"""

import json
import os
import signal
import threading
import time
from http.server import BaseHTTPRequestHandler, HTTPServer

ENV_DATA_PATH   = "DIUN_EXPORTER_DATA_PATH"
ENV_TTL_SECONDS = "DIUN_EXPORTER_TTL_SECONDS"

DATA_PATH_DEFAULT   = "/data"
TTL_SECONDS_DEFAULT ="86400" # 1 day

PORT        = 8080
STATE_FILE  = os.path.join(os.environ.get(ENV_DATA_PATH, DATA_PATH_DEFAULT) ,"state.json")
TTL_SECONDS = int(os.environ.get(ENV_TTL_SECONDS, TTL_SECONDS_DEFAULT))

_lock = threading.Lock()
_upgradable: dict = {}   # key: "resource|namespace|image" -> entry dict
_shutting_down = False   # set by signal handler, blocks new webhook writes

def _now_ts() -> float:
    return time.time()

def _load_state() -> None:
    """Load persisted state from disk, evicting already-expired entries."""
    global _upgradable
    if not os.path.exists(STATE_FILE):
        return
    try:
        with open(STATE_FILE) as f:
            raw = json.load(f)
        cutoff = _now_ts() - TTL_SECONDS
        _upgradable = {k: v for k, v in raw.items() if v.get("ts", 0) >= cutoff}
        print(f"Loaded {len(_upgradable)} entries from state file "
              f"({len(raw) - len(_upgradable)} expired)")
    except Exception as e:
        print(f"Warning: could not load state file: {e}")
        _upgradable = {}

def _save_state() -> None:
    """Persist current state to disk. Must be called with _lock held."""
    try:
        tmp = STATE_FILE + ".tmp"
        with open(tmp, "w") as f:
            json.dump(_upgradable, f)
        os.replace(tmp, STATE_FILE)  # atomic on POSIX
    except Exception as e:
        print(f"Warning: could not save state file: {e}")

def _evict_expired() -> None:
    """Remove entries older than TTL. Must be called with _lock held."""
    cutoff = _now_ts() - TTL_SECONDS
    expired = [k for k, v in _upgradable.items() if v.get("ts", 0) < cutoff]
    for k in expired:
        del _upgradable[k]
    if expired:
        print(f"Evicted {len(expired)} expired entries")

def _record_event(payload: dict) -> None:
    print(f"Payload: {payload}")
    if _shutting_down:
        return
    status = payload.get("status", "")
    if status not in ("new", "update"):
        return

    meta          = payload.get("metadata", {})
    if meta is None:
      meta = {}
    namespace     = meta.get("pod_namespace", "unknown")
    pod_name      = meta.get("pod_name", "unknown")
    image         = payload.get("image", "unknown")

    key = f"{namespace}|{pod_name}|{image}"
    with _lock:
        _upgradable[key] = {
            "pod_name":  pod_name,
            "namespace": namespace,
            "image":     image,
            "status":    status,
            "ts":        _now_ts(),
            "last_seen": time.strftime("%Y-%m-%dT%H:%M:%SZ", time.gmtime()),
        }
        _save_state()

def _render_metrics() -> str:
    with _lock:
        _evict_expired()
        _save_state()
        snapshot = list(_upgradable.values())

    lines = []

    lines.append("# HELP diun_upgradable_images_total Number of images with a newer version available")
    lines.append("# TYPE diun_upgradable_images_total gauge")
    lines.append(f"diun_upgradable_images_total {len(snapshot)}")

    lines.append("# HELP diun_upgradable_image Image with a newer version available (value is always 1)")
    lines.append("# TYPE diun_upgradable_image gauge")

    for entry in snapshot:
        def esc(s: str) -> str:
            return s.replace("\\", "\\\\").replace('"', '\\"').replace("\n", "\\n")

        label = (
            f'pod_name="{esc(entry["pod_name"])}",'
            f'namespace="{esc(entry["namespace"])}",'
            f'image="{esc(entry["image"])}",'
            f'status="{esc(entry["status"])}",'
            f'last_seen="{esc(entry["last_seen"])}"'
        )
        lines.append(f"diun_upgradable_image{{{label}}} 1")

    lines.append("")
    return "\n".join(lines)


def _clear_state() -> None:
    with _lock:
        _upgradable.clear()
        _save_state()

# -- HTTP handler ------------------------------------------------------------

class Handler(BaseHTTPRequestHandler):

    def log_message(self, format, *args):
        pass

    def do_POST(self):
        if _shutting_down:
            self._respond(503, "Server shutting down")
        elif self.path == "/webhook":
            length = int(self.headers.get("Content-Length", 0))
            body = self.rfile.read(length)
            try:
                payload = json.loads(body)
            except json.JSONDecodeError:
                self._respond(400, "Bad Request: invalid JSON")
                return
            _record_event(payload)
            self._respond(200, "OK")

        elif self.path == "/clear":
            _clear_state()
            self._respond(200, "Cleared")

        else:
            self._respond(404, "Not Found")

    def do_GET(self):
        if self.path == "/metrics":
            if _shutting_down:
              self._respond(503, "Server shutting down")
            else:
              output = _render_metrics()
              self.send_response(200)
              self.send_header("Content-Type", "text/plain; version=0.0.4; charset=utf-8")
              self.end_headers()
              self.wfile.write(output.encode("utf-8"))
        elif self.path in ("/healthz"):
            self._respond(200, "OK")
        elif self.path in ("/readyz"):
            if _shutting_down:
              self._respond(503, "Server shutting down")
            else:
              self._respond(200, "OK")
        else:
            self._respond(404, "Not Found")

    def _respond(self, code: int, body: str) -> None:
        encoded = body.encode("utf-8")
        self.send_response(code)
        self.send_header("Content-Type", "text/plain; charset=utf-8")
        self.send_header("Content-Length", str(len(encoded)))
        self.end_headers()
        self.wfile.write(encoded)

# -- Entrypoint --------------------------------------------------------------

if __name__ == "__main__":
    _load_state()
    server = HTTPServer(("0.0.0.0", PORT), Handler)

    def _shutdown(signum, frame):
        global _shutting_down
        sig_name = signal.Signals(signum).name
        print(f"Received {sig_name}, shutting down gracefully...")
        _shutting_down = True
        # Shut down the HTTP server from a separate thread to avoid deadlock
        # (signal handlers run on the main thread, which serve_forever() occupies)
        threading.Thread(target=server.shutdown, daemon=True).start()
        
        # Final eviction + save before exiting
        with _lock:
            _evict_expired()
            _save_state()

    signal.signal(signal.SIGTERM, _shutdown)
    signal.signal(signal.SIGINT, _shutdown)

    print(f"diun-exporter listening on :{PORT}")
    print(f"  POST /webhook  - receive Diun notifications")
    print(f"  GET  /metrics  - Prometheus exposition format")
    print(f"  GET  /healthz  - liveness probe")
    print(f"  GET  /readyz   - readiness probe")
    print(f"  POST /clear    - remove all entries")
    server.serve_forever()
    print("Shutdown complete")