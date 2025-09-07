import {
  to = proxmox_lxc.jellyfin
  id = "hypervisor/vm/102"
  #provider = proxmox
}

# __generated__ by OpenTofu
# Please review these resources and move them into your main configuration files.

# __generated__ by OpenTofu from "hypervisor/vm/102"
resource "proxmox_lxc" "jellyfin" {
  lifecycle {
    ignore_changes = [ tags ]
  }
  arch                 = "amd64"
  cmode                = ""
  console              = true
  cores                = 2
  cpuunits             = 1024
  description          = "<div align='center'>\n  <a href='https://Helper-Scripts.com' target='_blank' rel='noopener noreferrer'>\n    <img src='https://raw.githubusercontent.com/community-scripts/ProxmoxVE/main/misc/images/logo-81x112.png' alt='Logo' style='width:81px;height:112px;'/>\n  </a>\n\n  <h2 style='font-size: 24px; margin: 20px 0;'>Jellyfin LXC</h2>\n\n  <p style='margin: 16px 0;'>\n    <a href='https://ko-fi.com/community_scripts' target='_blank' rel='noopener noreferrer'>\n      <img src='https://img.shields.io/badge/&#x2615;-Buy us a coffee-blue' alt='spend Coffee' />\n    </a>\n  </p>\n  \n  <span style='margin: 0 10px;'>\n    <i class=\"fa fa-github fa-fw\" style=\"color: #f5f5f5;\"></i>\n    <a href='https://github.com/community-scripts/ProxmoxVE' target='_blank' rel='noopener noreferrer' style='text-decoration: none; color: #00617f;'>GitHub</a>\n  </span>\n  <span style='margin: 0 10px;'>\n    <i class=\"fa fa-comments fa-fw\" style=\"color: #f5f5f5;\"></i>\n    <a href='https://github.com/community-scripts/ProxmoxVE/discussions' target='_blank' rel='noopener noreferrer' style='text-decoration: none; color: #00617f;'>Discussions</a>\n  </span>\n  <span style='margin: 0 10px;'>\n    <i class=\"fa fa-exclamation-circle fa-fw\" style=\"color: #f5f5f5;\"></i>\n    <a href='https://github.com/community-scripts/ProxmoxVE/issues' target='_blank' rel='noopener noreferrer' style='text-decoration: none; color: #00617f;'>Issues</a>\n  </span>\n</div>\n"
  force                = false
  hagroup              = ""
  hastate              = ""
  hostname             = "jellyfin"
  memory               = 2048
  onboot               = true
  ostype               = "ubuntu"
  swap                 = 512
  tags                 = "100.124.239.35;192.168.1.40;community-script;media"
  target_node          = "hypervisor"
  tty                  = 2
  unprivileged         = true
  vmid                 = 102
  rootfs {
    size      = "8G"
    storage   = "" # local-lvm:vm-102-disk-0
  }
  mountpoint {
    key     = "0"
    slot    = 0
    storage = ""
    volume  = "/vm-zfs-pool/subvol-101-disk-0"
    mp      = "/srv/media"
  }
}
