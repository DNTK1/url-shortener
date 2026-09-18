data "proxmox_virtual_environment_nodes" "cluster" {}

output "proxmox_nodes" {
  value = data.proxmox_virtual_environment_nodes.cluster.names
}
