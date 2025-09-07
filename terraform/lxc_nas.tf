import {
  to = proxmox_lxc.nas
  id = "hypervisor/lxc/101"
  #provider = proxmox
}

# __generated__ by OpenTofu
# Please review these resources and move them into your main configuration files.

# __generated__ by OpenTofu from "hypervisor/lxc/101"
resource "proxmox_lxc" "nas" {
  lifecycle {
    ignore_changes = [ tags ]
  }
  arch                 = "amd64"
  clone                = null
  cmode                = ""
  cores                = 1
  cpulimit             = 0
  cpuunits             = 1024
  description          = ""
  force                = false
  full                 = null
  hagroup              = ""
  hastate              = ""
  hostname             = "nas"
  memory               = 1024
  onboot               = true
  ostype               = "alpine"
  start                = true
  swap                 = 1024
  tags                 = "100.117.71.29;172.17.0.1;192.168.1.30"
  target_node          = "hypervisor"
  template             = false
  tty                  = 2
  unique               = false
  unprivileged         = true
  vmid                 = 101
  rootfs {
    size      = "8G"
    storage   = "" # local-lvm:vm-101-disk-0
  }
  mountpoint {
    key     = "0"
    slot    = 0
    storage = "vm-zfs-pool"
    volume  = "vm-zfs-pool:subvol-101-disk-0"
    mp      = "/share/media"
    size    = "800G"
    backup  = true
  }
  mountpoint {
    key     = "1"
    slot    = 1
    storage = ""
    volume  = "/vm-zfs-pool/books"
    mp      = "/share/books"
  }
}
