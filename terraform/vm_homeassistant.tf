import {
  to = proxmox_vm_qemu.homeassistant
  id = "hypervisor/vm/100"
  #provider = proxmox
}
# __generated__ by OpenTofu
# Please review these resources and move them into your main configuration files.

# __generated__ by OpenTofu
resource "proxmox_vm_qemu" "homeassistant" {
  lifecycle {
    ignore_changes = [ 
      additional_wait,
      agent_timeout,
      clone_wait,
      skip_ipv4,
      skip_ipv6,
      tags
     ]
  }
  agent                       = 1
  args                        = ""
  automatic_reboot            = true
  balloon                     = 0
  bios                        = "ovmf"
  boot                        = "order=scsi0"
  bootdisk                    = ""
  clone                       = null
  define_connection_info      = false
  description                 = "<div align='center'><a href='https://Helper-Scripts.com' target='_blank' rel='noopener noreferrer'><img src='https://raw.githubusercontent.com/community-scripts/ProxmoxVE/main/misc/images/logo-81x112.png'/></a>\n\n  # Home Assistant OS\n\n  <a href='https://ko-fi.com/D1D7EP4GF'><img src='https://img.shields.io/badge/&#x2615;-Buy me a coffee-blue' /></a>\n  </div>"
  force_create                = false
  force_recreate_on_change_of = null
  full_clone                  = false
  hagroup                     = ""
  hastate                     = ""
  hotplug                     = "network,disk,usb"
  kvm                         = true
  machine                     = "pc"
  memory                      = 4096
  name                        = "homeassistant"
  onboot                      = true
  protection                  = false
  qemu_os                     = "l26"
  scsihw                      = "virtio-scsi-pci"
  tablet                      = false
  tags                        = "community-script"
  target_nodes                = ["hypervisor"]
  vm_state                    = "running"
  vmid                        = 100
  cpu {
    cores    = 2
    limit    = 0
    numa     = false
    sockets  = 1
    type     = "host"
    units    = 0
    vcores   = 0
  }
  disks {
    scsi {
      scsi0 {
        disk {
          backup               = true
          discard              = true
          emulatessd           = true
          cache                = "writethrough"
          format               = "raw"
          readonly             = false
          replicate            = true
          size                 = "32G"
          storage              = "local-lvm"
        }
      }
    }
  }
  network {
    bridge    = "vmbr0"
    firewall  = false
    id        = 0
    link_down = false
    macaddr   = "02:cd:56:57:17:5a"
    model     = "virtio"
    mtu       = 0
    queues    = 0
    rate      = 0
    tag       = 0
  }
  smbios {
    family       = ""
    manufacturer = ""
    product      = ""
    serial       = ""
    sku          = ""
    uuid         = "29736e1b-3aa7-4896-b83a-b487f048d613"
    version      = ""
  }
}

output "homeassistant" {
  value = {
    ansible_host  = proxmox_vm_qemu.homeassistant.name
    type          = "vm"
  }
}
