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
