#------------------------------------------------------------------------------------------
# Local Variables
#------------------------------------------------------------------------------------------

locals {
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
  source                        = "./modules/azure_nic"
  for_each                      = var.network_interfaces
  location_name                 = var.location_name
  network_name                  = each.value.vnet_name
  network_rg_name               = each.value.rg_name == null ? var.resource_group_name : each.value.rg_name
  nic_name                      = each.key
  resource_group_name           = var.resource_group_name
  subnet_name                   = each.value.subnet_name
  tags                          = var.tags
  enable_accelerated_networking = each.value.enable_accelerated_networking
  enable_ip_forwarding          = each.value.enable_ip_forwarding

  configurations = each.value.allocation == null ? null : {
    0 = {
      allocation         = each.value.allocation == null ? null : each.value.allocation,
      version            = each.value.version == null ? null : each.value.version,
      private_ip_address = each.value.private_ip == null ? null : each.value.private_ip
    }
  }

  depends_on = [
    azurerm_resource_group.resource_group,
    data.azurerm_resource_group.resource_group
  ]
}

#------------------------------------------------------------------------------------------
# Linux Virtual Machine
#------------------------------------------------------------------------------------------

resource "tls_private_key" "virtual_machine_ssh_key" {
  count     = var.vm_type == "Linux" && var.create_linux_key ? 1 : 0
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "azurerm_linux_virtual_machine" "virtual_machine" {
  count                      = var.vm_type == "Linux" ? 1 : 0
  name                       = var.vm_name
  resource_group_name        = var.resource_group_name
  location                   = var.location_name
  size                       = var.vm_sku
  admin_username             = local._admin_name
  allow_extension_operations = false
  network_interface_ids      = [for k, v in module.network_interfaces : v.nic_id]
  zone                       = var.zone
  computer_name              = local._computer_name
  license_type               = var.license_type
  provision_vm_agent         = true

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
  # patch_assessment_mode
  # patch_mode
  # plan
  # platform_fault_domain
  # priority
  # secret
  # secure_boot_enabledy
  # termination_notification
  # user_data
  # virtual_machine_scale_set_id
  # vtpm_enabled

  proximity_placement_group_id = var.proximity_group != null ? var.proximity_group : null

  admin_ssh_key {
    username   = local._admin_name
    public_key = var.vm_type == "Linux" && var.create_linux_key ? tls_private_key.virtual_machine_ssh_key[0].public_key_openssh : var.admin_ssh_key
  }

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

#------------------------------------------------------------------------------------------
# Windows Virtual Machine
#------------------------------------------------------------------------------------------

resource "random_password" "windows_password" {
  count            = var.vm_type == "Windows" && var.create_windows_password ? 1 : 0
  length           = 16
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
}

resource "azurerm_windows_virtual_machine" "virtual_machine" {
  count                      = var.vm_type == "Windows" ? 1 : 0
  name                       = var.vm_name
  resource_group_name        = var.resource_group_name
  location                   = var.location_name
  size                       = var.vm_sku
  admin_username             = local._admin_name
  allow_extension_operations = false
  network_interface_ids      = [for k, v in module.network_interfaces : v.nic_id]
  zone                       = var.zone
  computer_name              = local._computer_name
  license_type               = var.license_type
  admin_password             = var.vm_type == "Windows" && var.create_windows_password ? random_password.windows_password[0].result : var.admin_password
  provision_vm_agent         = true

  #----------------------------------
  # Builder pending section
  #----------------------------------
  # additional_capabilities
  # additional_unattend_content
  # allow_extension_operations
  # availability_set_id
  # capacity_reservation_group_id
  # computer_name
  # custom_data
  # dedicated_host_group_id
  # dedicated_host_id
  # edge_zone
  # enable_automatic_updates
  # encryption_at_host_enabled
  # eviction_policy
  # extensions_time_budget
  # gallery_application
  # hotpatching_enabled
  # identity
  # license_type
  # location
  # max_bid_price
  # patch_assessment_mode
  # patch_mode
  # plan
  # platform_fault_domain
  # priority
  # resource_group_name
  # secret
  # secure_boot_enabled
  # termination_notification
  # timezone
  # user_data
  # virtual_machine_scale_set_id
  # vtpm_enabled
  # winrm_listener

  proximity_placement_group_id = var.proximity_group != null ? var.proximity_group : null

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

#------------------------------------------------------------------------------------------
# Data Disks
#------------------------------------------------------------------------------------------

module "data_disks" {
  source              = "./modules/azure_disk"
  for_each            = var.data_disks
  resource_group_name = var.resource_group_name
  location_name       = var.location_name
  name                = each.value.name == null ? "${var.vm_name}-datadisk${index(keys(var.data_disks), each.key)}" : each.value.name
  attach              = true
  size                = each.value.size
  zone                = tonumber(var.zone)
  lun                 = each.key
  tags                = var.tags
  virtual_machine_id  = var.vm_type == "Windows" ? azurerm_windows_virtual_machine.virtual_machine[0].id : azurerm_linux_virtual_machine.virtual_machine[0].id
  storage_type        = each.value.storage_type
  create_option       = each.value.create_option
  caching             = each.value.caching
  write_accelerator   = each.value.write_accelerator
  depends_on = [
    azurerm_linux_virtual_machine.virtual_machine,
    azurerm_windows_virtual_machine.virtual_machine
  ]
}
