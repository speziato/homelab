resource "proxmox_lxc" "glance" {
  lifecycle {
    ignore_changes = [ tags ]
  }
  arch                 = "amd64"
  clone                = "alpine-lxc-template"
  cmode                = ""
  console              = true
  cores                = 1
  cpuunits             = 1024
  description          = ""
  force                = false
  full                 = true
  hagroup              = ""
  hastate              = ""
  hookscript           = ""
  hostname             = "glance"
  memory               = 512
  onboot               = true
  ostype               = "alpine"
  swap                 = 512
  start                = true
  tags                 = ""
  target_node          = "hypervisor"
  tty                  = 2
  unprivileged         = true
  rootfs {
    size      = "8G"
    storage   = ""
  }
}

output "glance" {
  value = {
    ansible_host  = proxmox_lxc.glance.hostname
    type          = "lxc"
  }
}
