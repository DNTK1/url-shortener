output "url_shortener_ipv4_addresses" {
  description = "Odczytane adresy IP"
  value       = proxmox_virtual_environment_vm.url_shortener_test.ipv4_addresses
}
