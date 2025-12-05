# Homelab setup

This repository holds my IaC and workload manifests to manage my homelab.

## Folder structure

- [talos](./talos/): contains Talos configuration manifests and mise tasks to generate machine config, `talosconfig` and `kubeconfig` files
- [sd](./sd): contains [SIGHUP Distribution](https://docs.sighup.io) configuration to provide monitoring, ingress and other infra components (CSI provisioner, external-dns, KubeVirt etc.) to the Kube cluster. The components are:
  - zfs-localpv from OpenEBS to provision PVCs using a ZFS pool. This is a nice and clean way to provide local storage PVCs with actual quota enfocement.
  - MetalLB to get LoadBalancer services with LAN IPs
  - external-dns to automatically create DNS entries in my domain when creating properly annotated Service resources. I created a LoadBalancer service for the Ingress Controller, annotated to allow external-dns to create the DNS record for it. MetalLB will give a LAN IP, so the DNS record will result in a name only reachable from within my network, for which I will have a valid HTTPS certificate with cert-manager.
  - Tailscale Operator to expose stuff inside my tailnet; I created a single-node ProxyGroup, which will handle all tailscale traffic towards the cluster. When I want to expose something to the tailnet, I just create a LoadBalancer service with the appropriate annotation to use the Proxy and the `loadBalancerClass: tailscale` parameter.
  - KubeVirt to run VMs inside the cluster. This is mainly needed for HomeAssistant, but I'm thinking about migrating away from the VM approach. Still, it's nice to be able to run VMs at will!
- [workload](./workload/): contains the workload I want to deploy in my lab.
  - To expose something to the internet, right now I manually edit a configuration file inside a reverse-proxy VM in a public cloud provider, which has a manually-created A record in my DNS zone and is also in the tailnet. I want to change my approach for this, WIP.
