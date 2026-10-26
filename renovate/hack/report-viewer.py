#!/usr/bin/env python3
"""Human-friendly view of a Renovate report (RENOVATE_REPORT_TYPE=file).
usage: renovate-report.py report.json [--skips]"""
import json, re, sys
from collections import Counter, defaultdict

path = next((a for a in sys.argv[1:] if not a.startswith("--")), None)
if not path:
    sys.exit(__doc__)
rep = json.load(open(path))
DIGEST = re.compile(r"^sha256:[a-f0-9]{64}$")
short = lambda x: (x[:15] + "…") if x else "-"

updates, skips, warns, counts = defaultdict(list), [], [], Counter()
for p in rep.get("problems", []):
    warns.append(p.get("msg", "?"))
for repo in rep.get("repositories", {}).values():
    warns += [p.get("msg", "?") for p in repo.get("problems", [])]
    for mgr, files in repo.get("packageFiles", {}).items():
        for f in files:
            for d in f.get("deps", []):
                counts[mgr] += 1
                name, cur, dg = d.get("depName", "?"), d.get("currentValue") or "-", d.get("currentDigest")
                if dg and not DIGEST.match(dg):
                    warns.append(f"malformed digest '{short(dg)}' on {name} ({f['packageFile']})")
                if d.get("skipReason"):
                    if d.get("datasource") != "kubernetes-api":
                        skips.append((d["skipReason"], mgr, name, cur, f["packageFile"]))
                    continue
                for u in d.get("updates", []):
                    kind = u.get("updateType", "?")
                    change = (f"{cur} digest {short(dg)} -> {short(u.get('newDigest'))}" if kind == "digest"
                              else f"{cur} -> {u.get('newValue', '-')}")
                    flag = kind + (" BREAKING" if u.get("isBreaking") else "")
                    updates[u.get("branchName", "?")].append((mgr, name, change, flag, f["packageFile"]))

n = sum(len(v) for v in updates.values())
print(f"== UPDATES: {n} in {len(updates)} branches ==")
for branch, items in sorted(updates.items()):
    print(branch)
    for mgr, name, change, flag, pf in items:
        print(f"  {mgr:10} {name:42} {change:50} {flag:16} {pf}")
print(f"\n== WARNINGS: {len(warns)} ==")
for w in warns: print("  !", w)
print(f"\n== SKIPPED (excluding kubernetes-api): {len(skips)} ==")
for reason, c in Counter(s[0] for s in skips).most_common(): print(f"  {reason}: {c}")
if "--skips" in sys.argv:
    for reason, mgr, name, cur, pf in sorted(skips): print(f"    {reason:12} {mgr:10} {name:36} {cur:12} {pf}")
print("\n== DEPS PER MANAGER ==", dict(counts))
