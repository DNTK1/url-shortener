output "vm_ipv4_addresses" {
  description = "Odczytane adresy IP"

  value = {
    for vm_name, vm in proxmox_virtual_environment_vm.vms :
    vm_name => vm.ipv4_addresses
  }
}
