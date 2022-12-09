# Módulo para la creación de NIC en Azure
Este módulo crea una interfaz de red en Azure. El recurso a emplear es [azurerm_network_interface](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_interface).

Aquí está la lista de parámetros totales para su referencia:
* https://github.com/hashicorp/terraform-provider-azurerm/blob/main/website/docs/r/network_interface.html.markdown

---
**NOTA**: Módulo aún en desarrollo, se recomienda no emplearlo en entornos de producción, pendiente secciones:
  * ip_configuration 
  * dns_servers 
  * edge_zone 
  * internal_dns_name_label 
  
---

## Usage

```hcl
module "module_test" {
  source                        = "app.terraform.io/orion-global/azure_nic/azurerm"
  version                       = "1.1.2"
  network_rg_name               = "test-rg"
  network_name                  = "test-vnet"
  subnet_name                   = "test-subnet"
  resource_group_name           = "test-rg-2"
  location_name                 = "eastus"
  enable_accelerated_networking = true
  enable_ip_forwarding          = true
  tags = {
    "test" = "test"
  }
}
```

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name                                                                      | Version  |
| ------------------------------------------------------------------------- | -------- |
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.1.0 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm)       | >= 3.23  |

## Providers

| Name                                                          | Version |
| ------------------------------------------------------------- | ------- |
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | >= 3.23 |

## Modules

No modules.

## Resources

| Name                                                                                                                                       | Type        |
| ------------------------------------------------------------------------------------------------------------------------------------------ | ----------- |
| [azurerm_network_interface.nic](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_interface)         | resource    |
| [azurerm_resource_group.resource_group](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group)    | resource    |
| [azurerm_resource_group.resource_group](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/resource_group) | data source |
| [azurerm_resource_group.vnet_rg](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/resource_group)        | data source |
| [azurerm_subnet.subnet](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/subnet)                         | data source |
| [azurerm_virtual_network.vnet](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/virtual_network)         | data source |

## Inputs

| Name                                                                                                                          | Description                                                                                  | Type          | Default | Required |
| ----------------------------------------------------------------------------------------------------------------------------- | -------------------------------------------------------------------------------------------- | ------------- | ------- | :------: |
| <a name="input_create_resource_group"></a> [create\_resource\_group](#input\_create\_resource\_group)                         | Action for creation or not of the resource group                                             | `bool`        | `false` |    no    |
| <a name="input_enable_accelerated_networking"></a> [enable\_accelerated\_networking](#input\_enable\_accelerated\_networking) | Enable or disable accelerated networking                                                     | `bool`        | `false` |    no    |
| <a name="input_enable_ip_forwarding"></a> [enable\_ip\_forwarding](#input\_enable\_ip\_forwarding)                            | Enable or disable IP forwarding                                                              | `bool`        | `false` |    no    |
| <a name="input_location_name"></a> [location\_name](#input\_location\_name)                                                   | The Azure location where all resources in this example should be created.                    | `string`      | `null`  |    no    |
| <a name="input_network_name"></a> [network\_name](#input\_network\_name)                                                      | Name of the Virtual Network for the VM                                                       | `string`      | `null`  |    no    |
| <a name="input_network_rg_name"></a> [network\_rg\_name](#input\_network\_rg\_name)                                           | Name of the resource group where the network is located                                      | `string`      | `null`  |    no    |
| <a name="input_nic_name"></a> [nic\_name](#input\_nic\_name)                                                                  | Name of the NIC to be created                                                                | `string`      | `null`  |    no    |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name)                               | Name of the resource group where the NIC will be created                                     | `string`      | `null`  |    no    |
| <a name="input_subnet_name"></a> [subnet\_name](#input\_subnet\_name)                                                         | Name of the Subnet for the VM. Must be part of the network\_name                             | `string`      | `null`  |    no    |
| <a name="input_tags"></a> [tags](#input\_tags)                                                                                | (Optional) A mapping of tags to assign to the resource. Use the map of {tag = value} format. | `map(string)` | `{}`    |    no    |

## Outputs

| Name                                                                               | Description                                     |
| ---------------------------------------------------------------------------------- | ----------------------------------------------- |
| <a name="output_nic_id"></a> [nic\_id](#output\_nic\_id)                           | The ID of the Network Interface                 |
| <a name="output_nic_name"></a> [nic\_name](#output\_nic\_name)                     | The name of the Network Interface               |
| <a name="output_nic_private_ip"></a> [nic\_private\_ip](#output\_nic\_private\_ip) | The private IP address of the Network Interface |
<!-- END_TF_DOCS -->

## License

MIT Licensed. See [LICENSE](https://github.com/orion-global/terraform-module-template/tree/prod/LICENSE) for full details.