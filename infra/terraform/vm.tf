resource "proxmox_virtual_environment_vm" "url_shortener_test" {
  name          = "url-shortener-test"
  node_name     = "Lab3"
  vm_id         = 200
  pool_id       = "url-shortener"
  scsi_hardware = "virtio-scsi-single"
  started       = true
  on_boot       = false

  cpu {
    cores = 2
    type  = "x86-64-v3"
  }

  memory {
    dedicated = 2048
    floating  = 0
  }

  network_device {
    bridge  = "vmbr0"
    model   = "virtio"
    vlan_id = 90
  }

  agent {
    enabled = true

    wait_for_ip {
      ipv4 = true
    }
  }

  clone {
    vm_id     = 9000
    node_name = "Lab3"
    full      = true
  }

  initialization {
    datastore_id = "RBD-POOL"
    interface    = "ide2"

    ip_config {
      ipv4 {
        address = "dhcp"
      }
    }

    dns {
      domain  = "domena.lab"
      servers = ["10.20.0.10", "10.20.0.11"]
    }

    user_account {
      username = "ansible"
      keys     = [trimspace(file("${path.module}/keys/AnsibleVM.pub"))]
    }
  }
}

