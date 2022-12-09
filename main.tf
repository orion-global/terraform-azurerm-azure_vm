#------------------------------------------------------------------------------------------
# Local Variables
#------------------------------------------------------------------------------------------

locals {
  _linux_machine = var.vm_type == "Linux" ? 1 : 0
  _admin_name    = var.admin_name == null ? "adminuser" : var.admin_name
}

#------------------------------------------------------------------------------------------
# Resource Group
#------------------------------------------------------------------------------------------

resource "azurerm_resource_group" "resource_group" {
  count    = var.create_resource_group ? 1 : 0
  name     = var.resource_group_name
  location = var.location_name
  tags     = var.tags
}

data "azurerm_resource_group" "resource_group" {
  count = var.create_resource_group ? 0 : 1
  name  = var.resource_group_name
}

#------------------------------------------------------------------------------------------
# Networking Configuration
#------------------------------------------------------------------------------------------

module "nic" {
  source              = "./modules/azure_nic"
  network_rg_name     = var.network_rg_name
  network_name        = var.network_name
  subnet_name         = var.subnet_name
  resource_group_name = azurerm_resource_group.resource_group[0].name
  location_name       = azurerm_resource_group.resource_group[0].location
  tags                = var.tags
}

#------------------------------------------------------------------------------------------
# Linux Virtual Machine
#------------------------------------------------------------------------------------------

resource "azurerm_linux_virtual_machine" "virtual_machine" {
  name                       = var.vm_name
  resource_group_name        = azurerm_resource_group.resource_group[0].name
  location                   = azurerm_resource_group.resource_group[0].location
  size                       = var.vm_size
  admin_username             = local._admin_name
  allow_extension_operations = false
  network_interface_ids = [
    module.nic[0].nic_id
  ]

  admin_ssh_key {
    username   = local._admin_name
    public_key = file("./id_rsa.pub")
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }

  tags = var.tags
}
