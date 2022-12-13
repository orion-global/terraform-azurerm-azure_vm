# Módulo para la creación de Discos administrados en Azure
Este módulo crea un disco administrado en Azure y da la posibilidad de atacharlo a una VM existente. Los recursos a emplear son: 
* [azurerm_managed_disk](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/managed_disk)
* [azurerm_virtual_machine_data_disk_attachment](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_machine_data_disk_attachment)

Aquí está la lista de parámetros totales para su referencia:
* https://github.com/hashicorp/terraform-provider-azurerm/blob/main/website/docs/r/managed_disk.html.markdown
* https://github.com/hashicorp/terraform-provider-azurerm/blob/main/website/docs/r/virtual_machine_data_disk_attachment.html.markdown


## Usage

```hcl
module "module_test" {
  source                = "../../terraform-azurerm-azure_disk"
  create_resource_group = false
  resource_group_name   = "test-rg"
  location_name         = "eastus"
  name                  = "test-disk"
  size                  = 10
  zone                  = 1
  lun                   = 10
  attach                = true
  tags = {
    "test" = "test"
  }
  virtual_machine_id = "/subscriptions/XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXXX/resourceGroups/rg-001/providers/Microsoft.Compute/virtualMachines/vm01"
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

No modules.

## Resources

| Name | Type |
|------|------|
| [azurerm_managed_disk.disk](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/managed_disk) | resource |
| [azurerm_resource_group.resource_group](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group) | resource |
| [azurerm_virtual_machine_data_disk_attachment.disk_attach](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_machine_data_disk_attachment) | resource |
| [azurerm_resource_group.resource_group](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/resource_group) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_attach"></a> [attach](#input\_attach) | (Optional) Specifies if the disk should be attached to the virtual machine. Changing this forces a new resource to be created. | `bool` | `null` | no |
| <a name="input_caching"></a> [caching](#input\_caching) | (Optional) Specifies the caching requirements. Possible values are None, ReadOnly and ReadWrite. Changing this forces a new resource to be created. | `string` | `null` | no |
| <a name="input_create_option"></a> [create\_option](#input\_create\_option) | (Required) Specifies how the virtual machine should be created. Possible values are Copy, Empty, FromImage, Import, Restore and Upload. Changing this forces a new resource to be created. | `string` | `null` | no |
| <a name="input_create_resource_group"></a> [create\_resource\_group](#input\_create\_resource\_group) | Action for creation or not of the resource group | `bool` | `false` | no |
| <a name="input_location_name"></a> [location\_name](#input\_location\_name) | (Required) Specifies the supported Azure location where the resource exists. Changing this forces a new resource to be created. | `string` | `null` | no |
| <a name="input_lun"></a> [lun](#input\_lun) | Specifies the Logical Unit Number for the disk. Changing this forces a new resource to be created. | `number` | `null` | no |
| <a name="input_name"></a> [name](#input\_name) | (Required) Specifies the name of the Managed Disk. Changing this forces a new resource to be created. | `string` | `null` | no |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | (Required) The name of the resource group in which to create the Container Registry. Changing this forces a new resource to be created. | `string` | `null` | no |
| <a name="input_size"></a> [size](#input\_size) | (Optional) Specifies the size of an empty data disk in gigabytes. This element can be used to overwrite the name of the disk. Changing this forces a new resource to be created. | `number` | `null` | no |
| <a name="input_storage_type"></a> [storage\_type](#input\_storage\_type) | (Required) Specifies the storage account type for the managed disk. Possible values are Standard\_LRS, StandardSSD\_ZRS, Premium\_LRS, PremiumV2\_LRS, Premium\_ZRS, StandardSSD\_LRS and UltraSSD\_LRS. Changing this forces a new resource to be created. | `string` | `null` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | (Optional) A mapping of tags to assign to the resource. Use the map of {tag = value} format. | `map(string)` | `{}` | no |
| <a name="input_virtual_machine_id"></a> [virtual\_machine\_id](#input\_virtual\_machine\_id) | (Optional) Specifies the ID of the Virtual Machine that this disk will be attached to. Changing this forces a new resource to be created. | `string` | `null` | no |
| <a name="input_write_accelerator"></a> [write\_accelerator](#input\_write\_accelerator) | (Optional) Specifies whether writeAccelerator should be enabled or disabled on the disk. Changing this forces a new resource to be created. | `bool` | `null` | no |
| <a name="input_zone"></a> [zone](#input\_zone) | (Optional) Specifies the Logical zone for the disk. Changing this forces a new resource to be created. | `number` | `null` | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->

## License

MIT Licensed. See [LICENSE](https://github.com/orion-global/terraform-module-template/tree/prod/LICENSE) for full details.