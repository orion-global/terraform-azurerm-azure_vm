#------------------------------------------------------------------------------------------
# Local Variables
#------------------------------------------------------------------------------------------

locals {
  _linux_machine = var.vm_type == "Linux" ? 1 : 0
  _admin_name    = var.admin_name == null ? "adminuser" : var.admin_name
  _computer_name = var.computer_name == null ? var.vm_name : var.computer_name
  _os_disk_name  = var.os_disk.name == null ? "${var.vm_name}-osdisk" : var.os_disk.name
  _os_disk_cache = var.os_disk.caching == null ? "None" : var.os_disk.caching
  _os_disk_sku   = var.os_disk.sku == null ? "Standard_LRS" : var.os_disk.sku

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

module "network_interfaces" {
  source              = "./modules/azure_nic"
  for_each            = var.network_interfaces
  network_rg_name     = each.value.rg_name == null ? var.resource_group_name : each.value.rg_name
  nic_name            = each.key
  network_name        = each.value.vnet_name
  subnet_name         = each.value.subnet_name
  resource_group_name = var.resource_group_name
  location_name       = var.location_name
  tags                = var.tags
}

#------------------------------------------------------------------------------------------
# Linux Virtual Machine
#------------------------------------------------------------------------------------------

resource "tls_private_key" "virtual_machine_ssh_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "azurerm_linux_virtual_machine" "virtual_machine" {
  name                       = var.vm_name
  resource_group_name        = var.resource_group_name
  location                   = var.location_name
  size                       = var.vm_sku
  admin_username             = local._admin_name
  allow_extension_operations = false
  network_interface_ids      = [for k, v in module.network_interfaces : v.nic_id]
  zone                       = var.zones
  computer_name              = local._computer_name
  license_type               = var.license_type

  #------------------------------------------------------------------------------------------
  # Builder pending section
  #------------------------------------------------------------------------------------------
  # additional_capabilities
  # admin_password
  # availability_set_id
  # capacity_reservation_group_id
  # custom_data
  # dedicated_host_group_id
  # dedicated_host_id
  # disable_password_authentication
  # edge_zone
  # encryption_at_host_enabled
  # eviction_policy
  # extensions_time_budget
  # gallery_application
  # identity
  # max_bid_price
  # os_disk
  # patch_assessment_mode
  # patch_mode
  # plan
  # platform_fault_domain
  # priority
  # provision_vm_agent
  # proximity_placement_group_id
  # secret
  # secure_boot_enabledy
  # termination_notification
  # user_data
  # virtual_machine_scale_set_id
  # vtpm_enabled

  admin_ssh_key {
    username   = local._admin_name
    public_key = tls_private_key.virtual_machine_ssh_key.public_key_openssh
  }

  #------------------------------------------------------------------------------------------
  # Builder pending section
  #------------------------------------------------------------------------------------------
  # boot_diagnostics

  dynamic "boot_diagnostics" {
    for_each = (var.boot_diagnostics == true) ? [1] : []
    content {
      storage_account_uri = null
    }
  }

  os_disk {
    caching                   = local._os_disk_cache
    disk_size_gb              = var.os_disk.disk_size_gb
    name                      = local._os_disk_name
    storage_account_type      = local._os_disk_sku
    write_accelerator_enabled = var.os_disk.write_accelerator
  }

  #------------------------------------------------------------------------------------------
  # os_disk Builder pending section
  #------------------------------------------------------------------------------------------
  # diff_disk_settings(Optional) Adiff_disk_settingsblock as defined above. Changing this forces a new resource to be created.
  # disk_encryption_set_id
  # secure_vm_disk_encryption_set_id
  # security_encryption_type

  source_image_id = var.os_image_id == null ? null : var.os_image_id

  dynamic "source_image_reference" {
    for_each = (var.os_image_id == null ? [""] : [])
    content {
      publisher = var.os_image_reference.publisher
      offer     = var.os_image_reference.offer
      sku       = var.os_image_reference.sku
      version   = var.os_image_reference.version
    }
  }

  tags = var.tags
}
