# Homelab setup

This repository holds my IaC and workload manifests to manage my homelab.

## Folder structure

- [talos](./talos/): contains Talos configuration manifests and mise tasks to generate machine config, `talosconfig` and `kubeconfig` files
- [sd](./sd): contains [SIGHUP Distribution](https://docs.sighup.io) configuration to provide monitoring, ingress and other infra components (CSI provisioner, external-dns, KubeVirt etc.) to the Kube cluster. The additional components are:
  - `zfs-localpv` from OpenEBS to provision PVCs using a node-local ZFS pool, which has been pre-created manually (see [Talos' ZFS extension docs](https://github.com/siderolabs/extensions/blob/main/storage/zfs/README.md)). This is a nice and clean way to provide local storage PVCs with actual quota enforcement and snapshots.
  - `MetalLB` to get LoadBalancer services with LAN IPs. Right now, only the Ingress Controller uses this.
  - `external-dns` to automatically create DNS entries in my domain when creating properly annotated Service resources. I created a LoadBalancer Service for the Ingress Controller, annotated to allow `external-dns` to create the DNS record for it. `MetalLB` will give it a LAN IP, so the DNS record will result in a name only reachable from within my network; additionally, I also created a DNSEndpoint CR to provide a wildcard CNAME record that points to the Ingress DNS A record. This enables me to have LAN-only Ingresses with public DNS records and valid HTTPS certificates.
  - `Tailscale Operator` to expose stuff inside my tailnet; I created a single-node ProxyGroup, which will handle all tailscale traffic towards the cluster.
  - `KubeVirt` to run VMs inside the cluster. This is mainly needed for HomeAssistant, but I'm thinking about migrating away from the VM approach. Still, it's nice to be able to run VMs at will!
  - `Garage`: after MinIO's "never gonna ~~give you up~~ maintain this" announcements, I wanted to try something else to provide an object storage for my cluster, and Garage seems to tick all the boxes I need. It can also create a static web server from a bucket, much like the real S3; MinIO never offered this feature, and I might end up using it to host a simple static website.
- [workload](./workload/): contains the workload I want to deploy in my lab.
  - When I want to expose something to the tailnet, I just create a LoadBalancer service with the appropriate annotation to use the ProxyGroup and the `loadBalancerClass: tailscale` parameter.
  - To expose something to the internet, right now I manually edit a configuration file inside a reverse-proxy VM in a public cloud provider, which has a manually-created A record in my DNS zone and is also in the tailnet. I want to change my approach for this, WIP.
