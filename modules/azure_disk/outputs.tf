output "nic_id" {
  description = "The ID of the Network Interface"
  value       = azurerm_network_interface.nic.id
}

output "nic_name" {
  description = "The name of the Network Interface"
  value       = azurerm_network_interface.nic.name
}

output "nic_private_ip" {
  description = "The private IP address of the Network Interface"
  value       = azurerm_network_interface.nic.private_ip_address
}
