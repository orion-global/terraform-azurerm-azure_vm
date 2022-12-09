#------------------------------------------------------------------------------------------
# Local Variables
#------------------------------------------------------------------------------------------

locals {
  _nic_rg_name = var.resource_group_name == null ? var.network_rg_name : var.resource_group_name
  _nic_name    = var.nic_name == null ? "nic-00" : var.nic_name
}

#------------------------------------------------------------------------------------------
# Resource Group
#------------------------------------------------------------------------------------------

resource "azurerm_resource_group" "resource_group" {
  count    = var.create_resource_group ? 1 : 0
  name     = local._nic_rg_name
  location = var.location_name
  tags     = var.tags
}

data "azurerm_resource_group" "resource_group" {
  count = var.create_resource_group ? 0 : 1
  name  = local._nic_rg_name
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
# Network Interface Configuration
#------------------------------------------------------------------------------------------

resource "azurerm_network_interface" "nic" {
  name                          = local._nic_name
  location                      = data.azurerm_virtual_network.vnet.location
  resource_group_name           = var.resource_group_name == null ? data.azurerm_resource_group.vnet_rg.name : azurerm_resource_group.resource_group[0].name
  enable_accelerated_networking = var.enable_accelerated_networking
  enable_ip_forwarding          = var.enable_ip_forwarding

  ip_configuration {
    name                          = "internal"
    subnet_id                     = data.azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
  }

  #------------------------------------------------------------------------------------------
  # Construcción de la interfaz de red
  #------------------------------------------------------------------------------------------
  # ip_configuration 
  # dns_servers 
  # edge_zone 
  # internal_dns_name_label 

  tags = var.tags
}
