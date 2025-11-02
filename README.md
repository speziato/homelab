# Homelab setup

This repository holds my IaC to manage my homelab.

## Repo structure

I'm experimenting with this kind of management: each branch will contain a specific set of resources, and all branches are current. I don't know if this will be effective or not, I'm just trying it.

The list of branches is:

- [`common/iac`](https://github.com/speziato/homelab/tree/common/iac) - OpenTofu to manage LXC and VM creation + Ansible inventory and playbooks
- [`lxc/id-aware-proxy`](https://github.com/speziato/homelab/tree/lxc/id-aware-proxy) - Docker Compose architecture, cloned directly inside the LXC, to create and manage the reverse proxy with Dex and forward auth where supported
- [`lxc/media-server`](https://github.com/speziato/homelab/tree/lxc/media-server) - Docker Compose architecture, cloned directly inside the LXC, to create and manage a Jellyfin-based media server, together with qBittorrent and *arr stack.
- [`lxc/semaphore`](https://github.com/speziato/homelab/tree/lxc/semaphore) - Setup script for Semaphore, cloned directly inside the LXC.
