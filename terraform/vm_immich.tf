import {
  to = proxmox_vm_qemu.immich
  id = "hypervisor/vm/108"
  #provider = proxmox
}

# __generated__ by OpenTofu
# Please review these resources and move them into your main configuration files.

# __generated__ by OpenTofu
resource "proxmox_vm_qemu" "immich" {
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
  bios                        = "seabios"
  boot                        = "order=scsi0;net0"
  bootdisk                    = ""
  clone                       = null
  define_connection_info      = false
  description                 = ""
  force_create                = false
  force_recreate_on_change_of = null
  full_clone                  = false
  hagroup                     = ""
  hastate                     = ""
  hotplug                     = "network,disk,usb"
  kvm                         = true
  machine                     = "pc"
  memory                      = 4096
  name                        = "immich"
  onboot                      = true
  protection                  = false
  qemu_os                     = "l26"
  scsihw                      = "virtio-scsi-single"
  tablet                      = true
  tags                        = ""
  target_nodes                = ["hypervisor"]
  vm_state                    = "running"
  vmid                        = 108
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
          discard              = false
          emulatessd           = false
          format               = "raw"
          iothread             = true
          readonly             = false
          replicate            = true
          size                 = "15G"
          storage              = "local-lvm"
        }
      }
      scsi1 {
        disk {
          backup               = true
          discard              = false
          emulatessd           = false
          format               = "raw"
          iothread             = true
          readonly             = false
          replicate            = true
          size                 = "100G"
          storage              = "vm-zfs-pool"
        }
      }
    }
  }
  network {
    bridge    = "vmbr0"
    firewall  = true
    id        = 0
    link_down = false
    macaddr   = "bc:24:11:90:79:35"
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
    uuid         = "89333523-7da4-4b26-afa1-2fc84736b9ba"
    version      = ""
  }
}

output "immich" {
  value = {
    ansible_host  = proxmox_vm_qemu.immich.name
    type          = "vm"
  }
}
