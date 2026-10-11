variable "vms" {
  type = map(object({
    name      = string
    vm_id     = number
    node_name = string
    cores     = number
    memory    = number
    disk      = number
    ip        = string
  }))

  default = {
    cp01 = {
      name      = "cp01"
      vm_id     = 200
      node_name = "Lab3"
      cores     = 2
      memory    = 4096
      disk      = 40
      ip        = "10.90.0.11/24"
    }
    worker01 = {
      name      = "worker01"
      vm_id     = 201
      node_name = "Lab1"
      cores     = 2
      memory    = 4096
      disk      = 40
      ip        = "10.90.0.21/24"
    }
    worker02 = {
      name      = "worker02"
      vm_id     = 202
      node_name = "Lab4"
      cores     = 2
      memory    = 4096
      disk      = 40
      ip        = "10.90.0.22/24"
    }
    worker03 = {
      name      = "worker03"
      vm_id     = 203
      node_name = "Lab5"
      cores     = 2
      memory    = 4096
      disk      = 40
      ip        = "10.90.0.23/24"
    }
  }
}
