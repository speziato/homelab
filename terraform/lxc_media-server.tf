# __generated__ by OpenTofu
# Please review these resources and move them into your main configuration files.

# __generated__ by OpenTofu from "hypervisor/lxc/104"
resource "proxmox_lxc" "media-server" {
  arch                 = "amd64"
  bwlimit              = 0
  clone                = null
  clone_storage        = null
  cmode                = ""
  console              = true
  cores                = 4
  cpulimit             = 0
  cpuunits             = 1024
  description          = ""
  force                = false
  full                 = null
  hagroup              = ""
  hastate              = ""
  hookscript           = ""
  hostname             = "media-server"
  ignore_unpack_errors = false
  lock                 = ""
  memory               = 4096
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
  start                = null
  startup              = ""
  swap                 = 512
  tags                 = "172.17.0.1;172.18.0.1;192.168.1.235;media"
  target_node          = null
  template             = false
  tty                  = 2
  unique               = false
  unprivileged         = true
  vmid                 = 104
  rootfs {
    acl       = false
    quota     = false
    replicate = false
    ro        = false
    shared    = false
    size      = "8G"
    storage   = ""
  }
  mountpoint {
    key     = "0"
    slot    = 0
    storage = ""
    volume  = "/vm-zfs-pool/subvol-104-disk-1"
    mp      = "/data"
  }
}
