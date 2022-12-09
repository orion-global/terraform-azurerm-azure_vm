module "module_test" {
  source                = "../../terraform-azurerm-azure_vm"
  vm_type               = "Linux"
  create_resource_group = false
  resource_group_name   = "test-rg"
  location_name         = "eastus"
  admin_name            = "test-admin"
  vm_size               = "Standard_F2"
  vm_name               = "test-vm"
  network_interfaces = {
    nic-0 = { rg_name = "test-rg", vnet_name = "test-vnet", subnet_name = "test-subnet" }
    nic-1 = { rg_name = "test-rg", vnet_name = "test-vnet", subnet_name = "test-subnet" }
  }
  tags = {
    "test" = "test"
  }

}
