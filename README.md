# Módulo para la creación de Virtual Machines en Azure
Este módulo crea una VM en Azure tanto para Windows como Linux. Los recursos a emplear son: 
* [azurerm_linux_virtual_machine](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/linux_virtual_machine)
* [azurerm_windows_virtual_machine](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/windows_virtual_machine)

Aquí está la lista de parámetros totales para su referencia:
* https://github.com/hashicorp/terraform-provider-azurerm/blob/main/website/docs/r/linux_virtual_machine.html.markdown
* https://github.com/hashicorp/terraform-provider-azurerm/blob/main/website/docs/r/windows_virtual_machine.html.markdown

---
**NOTA**: Módulo aún en desarrollo, se recomienda no emplearlo en entornos de producción. Pendientes:
  * Todo el recurso en Windows
  * Recurso en Linux:
  *  additional_capabilities
  *  admin_password
  *  availability_set_id
  *  capacity_reservation_group_id
  *  custom_data
  *  dedicated_host_group_id
  *  dedicated_host_id
  *  disable_password_authentication
  *  edge_zone
  *  encryption_at_host_enabled
  *  eviction_policy
  *  extensions_time_budget
  *  gallery_application
  *  identity
  *  max_bid_price
  *  patch_assessment_mode
  *  patch_mode
  *  plan
  *  platform_fault_domain
  *  priority
  *  provision_vm_agent
  *  proximity_placement_group_id
  *  secret
  *  secure_boot_enabledy
  *  termination_notification
  *  user_data
  *  virtual_machine_scale_set_id
  *  vtpm_enabled
  *  os_disk
    *  diff_disk_settings(Optional) Adiff_disk_settingsblock as defined above. Changing this forces a new resource to be created.
    *  disk_encryption_set_id
    *  secure_vm_disk_encryption_set_id
    *  security_encryption_type

---

## Usage

```hcl
module "module_test" {
  source                = "../../terraform-azurerm-azure_vm"
  vm_type               = "Linux"
  create_resource_group = true
  resource_group_name   = "test-rg"
  location_name         = "eastus"
  network_rg_name       = "test-rg"
  network_name          = "test-vnet"
  subnet_name           = "test-subnet"
  admin_name            = "test-admin"
  vm_sku               = "Standard_F2"
  vm_name               = "test-vm"
  network_interfaces = {
    nic-0 = { enable_zone_redundancy = true, enable_regional_endpoint = true }
    nic-1 = { enable_zone_redundancy = false, enable_regional_endpoint = true }
  }
  tags = {
    "test" = "test"
  }

}
```

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.1.0 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | >= 3.23 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | >= 3.23 |
| <a name="provider_random"></a> [random](#provider\_random) | n/a |
| <a name="provider_tls"></a> [tls](#provider\_tls) | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_data_disks"></a> [data\_disks](#module\_data\_disks) | orion-global/azure_disk/azurerm | 1.1.2 |
| <a name="module_network_interfaces"></a> [network\_interfaces](#module\_network\_interfaces) | orion-global/azure_nic/azurerm | 1.3.0 |

## Resources

| Name | Type |
|------|------|
| [azurerm_linux_virtual_machine.virtual_machine](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/linux_virtual_machine) | resource |
| [azurerm_resource_group.resource_group](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group) | resource |
| [azurerm_windows_virtual_machine.virtual_machine](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/windows_virtual_machine) | resource |
| [random_password.windows_password](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |
| [tls_private_key.virtual_machine_ssh_key](https://registry.terraform.io/providers/hashicorp/tls/latest/docs/resources/private_key) | resource |
| [azurerm_resource_group.resource_group](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/resource_group) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_admin_name"></a> [admin\_name](#input\_admin\_name) | The name of the administrator account for the VM. | `string` | `null` | no |
| <a name="input_admin_password"></a> [admin\_password](#input\_admin\_password) | The password associated with the admin\_name account. | `string` | `null` | no |
| <a name="input_admin_ssh_key"></a> [admin\_ssh\_key](#input\_admin\_ssh\_key) | The SSH public key associated with the admin\_name account. | `string` | `null` | no |
| <a name="input_allow_extension_operations"></a> [allow\_extension\_operations](#input\_allow\_extension\_operations) | Should the Virtual Machine be allowed to perform extension operations. | `bool` | `true` | no |
| <a name="input_boot_diagnostics"></a> [boot\_diagnostics](#input\_boot\_diagnostics) | Enable or disable boot diagnostics. It will use only Managed Storage Account. | `bool` | `null` | no |
| <a name="input_computer_name"></a> [computer\_name](#input\_computer\_name) | The computer name of the VM. If not specified, the VM name will be used as the computer name. | `string` | `null` | no |
| <a name="input_create_linux_key"></a> [create\_linux\_key](#input\_create\_linux\_key) | Action for creation of Linux SSH key or not | `bool` | `false` | no |
| <a name="input_create_resource_group"></a> [create\_resource\_group](#input\_create\_resource\_group) | Action for creation or not of the resource group | `bool` | `false` | no |
| <a name="input_create_windows_password"></a> [create\_windows\_password](#input\_create\_windows\_password) | Action for creation of Windows password or not using random string | `bool` | `false` | no |
| <a name="input_data_disks"></a> [data\_disks](#input\_data\_disks) | A list of data disks to attach to the VM. Use the Key for LUN number and all the other values for the disk configuration. | <pre>map(object({<br>    name              = optional(string)<br>    size              = number<br>    storage_type      = optional(string)<br>    create_option     = optional(string)<br>    caching           = optional(string)<br>    write_accelerator = optional(bool)<br>  }))</pre> | `null` | no |
| <a name="input_license_type"></a> [license\_type](#input\_license\_type) | Specifies the type of license that will be applied to the VM. Possible values are RHEL\_BYOS and SLES\_BYOS for Linux VMs. Possible values are None, Windows\_Client and Windows\_Server for Windows VMs. | `string` | `null` | no |
| <a name="input_location_name"></a> [location\_name](#input\_location\_name) | (Required) Specifies the supported Azure location where the resource exists. Changing this forces a new resource to be created. | `string` | `null` | no |
| <a name="input_network_interfaces"></a> [network\_interfaces](#input\_network\_interfaces) | A list of network interface IDs to attach to the VM. | <pre>map(object({<br>    rg_name                       = optional(string)<br>    vnet_name                     = string<br>    subnet_name                   = string<br>    private_ip                    = optional(string)<br>    allocation                    = optional(string)<br>    version                       = optional(string)<br>    enable_accelerated_networking = optional(bool)<br>    enable_ip_forwarding          = optional(bool)<br>    dns_servers                   = optional(list(string))<br>  }))</pre> | `null` | no |
| <a name="input_os_disk"></a> [os\_disk](#input\_os\_disk) | A os\_disk block as defined below. | <pre>object({<br>    caching           = optional(string)<br>    disk_size_gb      = number<br>    name              = optional(string)<br>    sku               = optional(string) # Standard_LRS, StandardSSD_LRS, Premium_LRS, StandardSSD_ZRS, Premium_ZRS<br>    write_accelerator = optional(string)<br>  })</pre> | `null` | no |
| <a name="input_os_image_id"></a> [os\_image\_id](#input\_os\_image\_id) | The ID of a custom image to use for the VM. This can be specified instead of a `os_source_image` to reference a custom image. | `string` | `null` | no |
| <a name="input_os_image_reference"></a> [os\_image\_reference](#input\_os\_image\_reference) | Information of the OS image to use for the VM. This can be specified instead of a `source_image_id` to reference a published image in the Azure Marketplace. The `offer`, `publisher`, `sku` and `version` can be found by running `az vm image list` or in the Azure Portal. The `version` can be omitted to use the latest version. | <pre>object({<br>    publisher = string<br>    offer     = string<br>    sku       = string<br>    version   = string<br>  })</pre> | `null` | no |
| <a name="input_provision_vm_agent"></a> [provision\_vm\_agent](#input\_provision\_vm\_agent) | Should the Virtual Machine Agent be provisioned. | `bool` | `true` | no |
| <a name="input_proximity_group"></a> [proximity\_group](#input\_proximity\_group) | The ID of the Proximity Placement Group to use for the VM. | `string` | `null` | no |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | (Required) The name of the resource group in which to create the Container Registry. Changing this forces a new resource to be created. | `string` | `null` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | (Optional) A mapping of tags to assign to the resource. Use the map of {tag = value} format. | `map(string)` | `{}` | no |
| <a name="input_vm_name"></a> [vm\_name](#input\_vm\_name) | The name of the VM. | `string` | `null` | no |
| <a name="input_vm_sku"></a> [vm\_sku](#input\_vm\_sku) | The size of the VM. | `string` | `null` | no |
| <a name="input_vm_type"></a> [vm\_type](#input\_vm\_type) | The id of the machine image (AMI) to use for the server. | `string` | n/a | yes |
| <a name="input_windows_password"></a> [windows\_password](#input\_windows\_password) | The password for administrator account of the Windows VM. | `string` | `null` | no |
| <a name="input_zone"></a> [zone](#input\_zone) | The availability zone in which the VM should be created. | `string` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_network_interfaces_ids"></a> [network\_interfaces\_ids](#output\_network\_interfaces\_ids) | n/a |
| <a name="output_network_interfaces_names"></a> [network\_interfaces\_names](#output\_network\_interfaces\_names) | n/a |
| <a name="output_network_interfaces_private_ips"></a> [network\_interfaces\_private\_ips](#output\_network\_interfaces\_private\_ips) | n/a |
| <a name="output_private_ssh_key"></a> [private\_ssh\_key](#output\_private\_ssh\_key) | n/a |
| <a name="output_virtual_machine_id"></a> [virtual\_machine\_id](#output\_virtual\_machine\_id) | n/a |
<!-- END_TF_DOCS -->

## License

MIT Licensed. See [LICENSE](https://github.com/orion-global/terraform-module-template/tree/prod/LICENSE) for full details.