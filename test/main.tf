module "module_test" {
  source                = "../../terraform-azurerm-azure_vm"
  vm_type               = "Linux"
  create_resource_group = false
  resource_group_name   = "test-rg"
  location_name         = "eastus"
  admin_name            = "test-admin"
  vm_sku                = "Standard_F2"
  vm_name               = "test-vm"
  zones                 = "1"
  license_type          = "SLES_BYOS"
  os_disk = {
    disk_size_gb = 30
  }

  network_interfaces = {
    nic-0 = { vnet_name = "test-vnet", subnet_name = "test-subnet" }
    nic-1 = { vnet_name = "test-vnet", subnet_name = "test-subnet" }
  }

  os_image_reference = {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }

  boot_diagnostics = false

  tags = {
    "test" = "test"
  }
}
