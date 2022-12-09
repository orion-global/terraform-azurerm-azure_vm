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
# Network Configuration
#------------------------------------------------------------------------------------------

data "azurerm_resource_group" "vnet_rg" {
  name = var.network_rg_name
}

data "azurerm_virtual_network" "vnet" {
  name                = var.network_name
  resource_group_name = data.azurerm_resource_group.vnet_rg.name
}

data "azurerm_subnet" "subnet" {
  name                 = var.subnet_name
  virtual_network_name = data.azurerm_virtual_network.vnet.name
  resource_group_name  = data.azurerm_resource_group.vnet_rg.name
}

#------------------------------------------------------------------------------------------
# Linux Virtual Machine
#------------------------------------------------------------------------------------------

resource "azurerm_network_interface" "nic" {
  name                = "example-nic"
  location            = azurerm_resource_group.resource_group[0].location
  resource_group_name = azurerm_resource_group.resource_group[0].name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = data.azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_linux_virtual_machine" "virtual_machine" {
  name                = var.vm_name
  resource_group_name = azurerm_resource_group.resource_group[0].name
  location            = azurerm_resource_group.resource_group[0].location
  size                = var.vm_size
  admin_username      = local._admin_name
  network_interface_ids = [
    azurerm_network_interface.nic.id,
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
}
