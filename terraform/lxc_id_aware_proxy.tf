import {
  to = proxmox_lxc.id-aware-proxy
  id = "hypervisor/vm/117"
  #provider = proxmox
}

# __generated__ by OpenTofu
# Please review these resources and move them into your main configuration files.

# __generated__ by OpenTofu from "hypervisor/vm/117"
resource "proxmox_lxc" "id-aware-proxy" {
  lifecycle {
    ignore_changes = [ tags ]
  }
  arch                 = "amd64"
  cmode                = ""
  console              = true
  cores                = 1
  cpuunits             = 1024
  description          = ""
  force                = false
  hagroup              = ""
  hastate              = ""
  hostname             = "id-aware-proxy"
  memory               = 512
  onboot               = true
  swap                 = 512
  tags                 = "100.93.250.75;172.17.0.1;172.18.0.1;172.19.0.1;192.168.1.233"
  target_node          = "hypervisor"
  tty                  = 2
  unprivileged         = true
  vmid                 = 117
  rootfs {
    size      = "8G"
    storage   = ""
  }
}

output "id-aware-proxy" {
  value = {
    ansible_host  = proxmox_lxc.id-aware-proxy.hostname
    type          = "lxc"
  }
}
