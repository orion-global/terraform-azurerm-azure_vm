output "network_interfaces_ids" {
  value = [for k, v in module.network_interfaces : v.nic_id]
}

output "network_interfaces_names" {
  value = [for k, v in module.network_interfaces : v.nic_name]
}

output "network_interfaces_private_ips" {
  value = [for k, v in module.network_interfaces : v.nic_private_ip]
}

output "private_ssh_key" {
  value     = var.vm_type == "Linux" && var.create_linux_key ? tls_private_key.virtual_machine_ssh_key[0].private_key_openssh : null
  sensitive = true
}

output "virtual_machine_id" {
  value = var.vm_type == "Linux" ? azurerm_linux_virtual_machine.virtual_machine[0].id : azurerm_windows_virtual_machine.virtual_machine[0].id
}
