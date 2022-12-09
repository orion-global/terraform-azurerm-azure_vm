# Módulo para la creación de Virtual Machines en Azure
Este módulo crea una VM en Azure tanto para Windows como Linux. Los recursos a emplear son: 
* [azurerm_linux_virtual_machine](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/linux_virtual_machine)
* [azurerm_windows_virtual_machine](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/windows_virtual_machine)

Aquí está la lista de parámetros totales para su referencia:
* https://github.com/hashicorp/terraform-provider-azurerm/blob/main/website/docs/r/linux_virtual_machine.html.markdown
* https://github.com/hashicorp/terraform-provider-azurerm/blob/main/website/docs/r/windows_virtual_machine.html.markdown

---
**NOTA**: Módulo aún en desarrollo, se recomienda no emplearlo en entornos de producción.

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
  vm_size               = "Standard_F2"
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

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_network_interfaces"></a> [network\_interfaces](#module\_network\_interfaces) | ./modules/azure_nic | n/a |

## Resources

| Name | Type |
|------|------|
| [azurerm_linux_virtual_machine.virtual_machine](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/linux_virtual_machine) | resource |
| [azurerm_resource_group.resource_group](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group) | resource |
| [azurerm_resource_group.resource_group](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/resource_group) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_admin_name"></a> [admin\_name](#input\_admin\_name) | The name of the administrator account for the VM. | `string` | `null` | no |
| <a name="input_create_resource_group"></a> [create\_resource\_group](#input\_create\_resource\_group) | Action for creation or not of the resource group | `bool` | `false` | no |
| <a name="input_location_name"></a> [location\_name](#input\_location\_name) | (Required) Specifies the supported Azure location where the resource exists. Changing this forces a new resource to be created. | `string` | `null` | no |
| <a name="input_network_interfaces"></a> [network\_interfaces](#input\_network\_interfaces) | A list of network interface IDs to attach to the VM. | <pre>map(object({<br>    rg_name     = string<br>    vnet_name   = string<br>    subnet_name = string<br>  }))</pre> | `null` | no |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | (Required) The name of the resource group in which to create the Container Registry. Changing this forces a new resource to be created. | `string` | `null` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | (Optional) A mapping of tags to assign to the resource. Use the map of {tag = value} format. | `map(string)` | `{}` | no |
| <a name="input_vm_name"></a> [vm\_name](#input\_vm\_name) | The name of the VM. | `string` | `null` | no |
| <a name="input_vm_size"></a> [vm\_size](#input\_vm\_size) | The size of the VM. | `string` | `null` | no |
| <a name="input_vm_type"></a> [vm\_type](#input\_vm\_type) | The id of the machine image (AMI) to use for the server. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_network_interfaces_ids"></a> [network\_interfaces\_ids](#output\_network\_interfaces\_ids) | n/a |
| <a name="output_network_interfaces_names"></a> [network\_interfaces\_names](#output\_network\_interfaces\_names) | n/a |
| <a name="output_network_interfaces_private_ips"></a> [network\_interfaces\_private\_ips](#output\_network\_interfaces\_private\_ips) | n/a |
<!-- END_TF_DOCS -->

## License

MIT Licensed. See [LICENSE](https://github.com/orion-global/terraform-module-template/tree/prod/LICENSE) for full details.