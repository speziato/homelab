import {
  to = proxmox_lxc.alpine-lxc-template
  id = "hypervisor/lxc/8000"
}

# __generated__ by OpenTofu
# Please review these resources and move them into your main configuration files.

# __generated__ by OpenTofu
resource "proxmox_lxc" "alpine-lxc-template" {
  lifecycle {
    ignore_changes = [ tags ]
  }
  arch                 = "amd64"
  bwlimit              = 0
  clone                = null
  clone_storage        = null
  cmode                = ""
  console              = true
  cores                = 1
  cpulimit             = 0
  cpuunits             = 1024
  description          = ""
  force                = false
  full                 = null
  hagroup              = ""
  hastate              = ""
  hookscript           = ""
  hostname             = "alpine-lxc-template"
  ignore_unpack_errors = false
  lock                 = ""
  memory               = 512
  nameserver           = ""
  onboot               = false
  ostemplate           = null
  ostype               = "alpine"
  password             = null # sensitive
  pool                 = null
  protection           = false
  restore              = false
  searchdomain         = ""
  ssh_public_keys      = null
  start                = false
  startup              = ""
  swap                 = 512
  tags                 = ""
  target_node          = null
  template             = true
  tty                  = 2
  unique               = false
  unprivileged         = true
  vmid                 = 8000
  rootfs {
    acl       = false
    quota     = false
    replicate = false
    ro        = false
    shared    = false
    size      = "8G"
    storage   = ""
  }
}

output "alpine-lxc-template" {
  value = {
    ansible_host  = proxmox_lxc.alpine-lxc-template.hostname
    type          = "lxc"
  }
}
