output "output_1" {
  value = module.module_test.network_interfaces_ids
}

output "output_2" {
  value = module.module_test.network_interfaces_names
}

output "output_3" {
  value = module.module_test.network_interfaces_private_ips
}

output "output_4" {
  value     = module.module_test.private_ssh_key
  sensitive = true
}
