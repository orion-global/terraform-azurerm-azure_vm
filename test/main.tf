module "module_test" {
  source                = "../../terraform-azurerm-azure_vm"
  vm_type               = "Linux"
  create_resource_group = true
  resource_group_name   = "test-rg"
  location_name         = "eastus"
  network_rg_name       = "test-rg"
  network_name          = "test-vnet"
  subnet_name           = "test-subnet"
  tags = {
    "test" = "test"
  }

}
