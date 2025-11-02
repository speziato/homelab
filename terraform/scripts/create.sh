#!/usr/bin/env bash
set -e

# Ask for type
read -rp "Enter resource type (lxc/vm): " TYPE
if [[ "$TYPE" != "lxc" && "$TYPE" != "vm" ]]; then
  echo "❌ Invalid type: $TYPE. Must be 'lxc' or 'vm'."
  exit 1
fi

# Ask for name
read -rp "Enter resource name: " NAME
if [[ -z "$NAME" ]]; then
  echo "❌ Resource name cannot be empty."
  exit 1
fi

# Ask for cpus
read -rp "Enter number of CPUs: " CPUS
if [[ -z "$CPUS" ]]; then
  echo "❌ Number of CPUs cannot be empty."
  exit 1
fi

# Ask for ram
read -rp "Enter amount of RAM (e.g.: 4096): " RAM
if [[ -z "$RAM" ]]; then
  echo "❌ Amount of RAM cannot be empty."
  exit 1
fi

# Ask for root fs size
read -rp "Enter size for root fs disk (e.g.: 8G): " ROOTFS_SIZE
if [[ -z "$ROOTFS_SIZE" ]]; then
  echo "❌ Size for root fs disk cannot be empty."
  exit 1
fi

# Determine resource type
if [[ "$TYPE" == "vm" ]]; then
  RESOURCE_TYPE="proxmox_vm_qemu"
else
  RESOURCE_TYPE="proxmox_lxc"
fi

TARGET_FILE="${TYPE}_${NAME}.tf"

# Create target file
if [ $TYPE = "lxc" ]; then
  cat > "$TARGET_FILE" <<EOF
resource "${RESOURCE_TYPE}" "${NAME}" {
  lifecycle {
    ignore_changes = [ tags ]
  }
  arch                 = "amd64"
  cmode                = ""
  console              = true
  cores                = ${CPUS}
  cpuunits             = 1024
  description          = ""
  force                = false
  hagroup              = ""
  hastate              = ""
  hookscript           = ""
  hostname             = "${NAME}"
  memory               = ${RAM}
  onboot               = true
  ostype               = "alpine"
  swap                 = 512
  start                = true
  tags                 = ""
  target_node          = "hypervisor"
  tty                  = 2
  unprivileged         = true
  rootfs {
    size      = "${ROOTFS_SIZE}"
    storage   = ""
  }
}

output "${NAME}" {
  value = {
    ansible_host  = ${RESOURCE_TYPE}.${NAME}.hostname
    type          = "${TYPE}"
  }
}
EOF
  else
  cat > "$TARGET_FILE" <<EOF
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
  memory                      = ${RAM}
  name                        = "${NAME}"
  onboot                      = true
  protection                  = false
  qemu_os                     = "l26"
  scsihw                      = "virtio-scsi-single"
  tablet                      = true
  tags                        = ""
  target_nodes                = ["hypervisor"]
  vm_state                    = "running"
  cpu {
    cores    = ${CPUS}
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
          size                 = "${ROOTFS_SIZE}"
          storage              = "local-lvm"
        }
      }
    }
  }
  network {
    bridge    = "vmbr0"
    firewall  = true
    id        = 0
    link_down = false
    model     = "virtio"
  }
}

output "${NAME}" {
  value = {
    ansible_host  = ${RESOURCE_TYPE}.${NAME}.name
    type          = "${TYPE}"
  }
}
EOF
  fi
echo "📝 Created $TARGET_FILE"
