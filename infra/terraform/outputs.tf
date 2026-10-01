output "url_shortener_ipv4_addresses" {
  description = "Odczytane adresy IP"
  value       = proxmox_virtual_environment_vm.vms["cp01"].ipv4_addresses
}
