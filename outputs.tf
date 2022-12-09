output "network_interfaces_ids" {
  value = [for k, v in module.network_interfaces : v.nic_id]
}

output "network_interfaces_names" {
  value = [for k, v in module.network_interfaces : v.nic_name]
}

output "network_interfaces_private_ips" {
  value = [for k, v in module.network_interfaces : v.nic_private_ip]
}
