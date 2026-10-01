variable "vms" {

  type = map(object({
    name      = string
    vm_id     = number
    node_name = string
    cores     = number
    memory    = number
  }))

  default = {
    cp01 = {
      name      = "url-shortener-test"
      vm_id     = 200
      node_name = "Lab3"
      cores     = 2
      memory    = 2048
    }
  }
}
