# Homelab setup

This repository holds my IaC to manage my homelab.

## Repo structure

I'm experimenting with this kind of management: each branch will contain a specific set of resources, and all branches are current. I don't know if this will be effective or not, I'm just trying it.

The list of branches is:

- [`feat/terraform`](https://github.com/speziato/homelab/tree/feat/terraform) - OpenTofu to manage LXC and VM creation
- [`lxc/id-aware-proxy`](https://github.com/speziato/homelab/tree/lxc/id-aware-proxy) - Docker Compose architecture, cloned directly inside the LXC, to create and manage the reverse proxy with Dex and forward auth where supported
- [`lxc/media-server`](https://github.com/speziato/homelab/tree/lxc/media-server) - Docker Compose architecture, cloned directly inside the LXC, to create and manage a Jellyfin-based media server, together with qBittorrent and *arr stack.
