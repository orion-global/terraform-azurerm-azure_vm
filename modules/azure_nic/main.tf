#------------------------------------------------------------------------------------------
# Local Variables
#------------------------------------------------------------------------------------------

locals {
  _nic_rg_name = var.resource_group_name == null ? var.network_rg_name : var.resource_group_name
  _nic_name    = var.nic_name == null ? "nic-00" : var.nic_name
  _nic_config = var.configurations == null ? tomap({
    0 = {
      name       = "ipconfig0",
      allocation = "Dynamic",
      version    = "IPv4"
    }
  }) : var.configurations
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
  location                      = var.location_name
  resource_group_name           = local._nic_rg_name
  enable_accelerated_networking = var.enable_accelerated_networking
  enable_ip_forwarding          = var.enable_ip_forwarding
  dns_servers                   = var.dns_servers

  dynamic "ip_configuration" {
    for_each = local._nic_config
    iterator = ipconfig
    content {
      name                          = "ipconfig${index(keys(local._nic_config), ipconfig.key)}"
      primary                       = index(keys(local._nic_config), ipconfig.key) == 0 ? true : false
      subnet_id                     = ipconfig.value.version == "IPv4" ? data.azurerm_subnet.subnet.id : null
      private_ip_address            = ipconfig.value.allocation == "Static" ? ipconfig.value.private_ip_address : null
      private_ip_address_allocation = ipconfig.value.allocation
      private_ip_address_version    = ipconfig.value.version
    }
  }

  #------------------------------------------------------------------------------------------
  # Construcción de la interfaz de red
  #------------------------------------------------------------------------------------------
  # ip_configuration
  #   public_ip_address_id
  # edge_zone
  # internal_dns_name_label

  tags = var.tags
}
