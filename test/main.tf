resource "tls_private_key" "linux_ssh_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}


module "linux_host" {
  source                 = "../../terraform-azurerm-azure_vm"
  vm_type                = "Linux"
  create_resource_group  = false
  resource_group_name    = "test-rg"
  location_name          = "eastus"
  admin_name             = "test-admin"
  vm_sku                 = "Standard_F2"
  vm_name                = "test-vm"
  zone                   = "1"
  admin_ssh_key          = tls_private_key.linux_ssh_key.public_key_openssh
  license_type           = "SLES_BYOS"
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
    10 = {
      size = 10,
      name = "disk0"
    }
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

resource "random_password" "windows_password" {
  length           = 16
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
}


module "windows_host" {
  source                 = "../../terraform-azurerm-azure_vm"
  vm_type                = "Windows"
  create_resource_group  = false
  resource_group_name    = "test-rg"
  location_name          = "eastus"
  admin_name             = "test-admin"
  vm_sku                 = "Standard_F2"
  vm_name                = "test-vm"
  zone                   = "1"
  license_type           = "Windows_Server"
  admin_password         = random_password.windows_password.result
  os_disk = {
    disk_size_gb = 60
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
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2019-Datacenter-smalldisk"
    version   = "latest"
  }

  boot_diagnostics = false

  tags = {
    "test" = "test"
  }
}
