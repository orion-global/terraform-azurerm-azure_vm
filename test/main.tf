module "module_test" {
  source                = "../../terraform-azurerm-azure_vm"
  vm_type               = "Linux"
  create_resource_group = false
  resource_group_name   = "test-rg"
  location_name         = "eastus"
  admin_name            = "test-admin"
  vm_sku                = "Standard_F2"
  vm_name               = "test-vm"
  zone                  = "1"
  license_type          = "SLES_BYOS"
  os_disk = {
    disk_size_gb = 30
  }

  network_interfaces = {
    nic-0 = {
      vnet_name   = "test-vnet",
      subnet_name = "test-subnet",
      allocation  = "Static",
      version     = "IPv4",
      private_ip  = "10.0.0.10"
    }
    nic-1 = {
      vnet_name   = "test-vnet",
      subnet_name = "test-subnet"
    }
  }

  data_disks = {
    10 = { size = 10 }
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
