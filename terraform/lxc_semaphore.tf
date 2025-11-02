resource "proxmox_lxc" "semaphore" {
  lifecycle {
    ignore_changes = [ tags ]
  }
  arch                 = "amd64"
  # Commented because it would cause recreation. I applied first with those uncommented,
  # then commented to edit some parameters.
  # clone                = "alpine-lxc-template"       # ID of your template container
  # full                 = true         # Full clone (independent copy)
  cmode                = ""
  console              = true
  cores                = 1
  cpuunits             = 1024
  description          = ""
  force                = false
  hagroup              = ""
  hastate              = ""
  hookscript           = ""
  hostname             = "semaphore"
  memory               = 1024
  onboot               = true
  ostype               = "alpine"
  swap                 = 512
  start                = true
  tags                 = ""
  target_node          = "hypervisor"
  tty                  = 2
  unprivileged         = true
  features {
    nesting = true
  }

  rootfs {
    size  = "8G"
    storage = ""
  }
  
}

output "semaphore" {
  value = {
    ansible_host  = proxmox_lxc.semaphore.hostname
    type          = "lxc"
  }
}
