#------------------------------------------------------------------------------------------
# Action variables
#------------------------------------------------------------------------------------------

variable "vm_type" {
  type        = string
  description = "The id of the machine image (AMI) to use for the server."

  validation {
    condition     = var.vm_type == "Linux" || var.vm_type == "Windows"
    error_message = "The vm_type value must be Linux or Windows."
  }
}

variable "create_resource_group" {
  description = "Action for creation or not of the resource group"
  type        = bool
  default     = false
}

variable "create_linux_key" {
  description = "Action for creation of Linux SSH key or not"
  type        = bool
  default     = false
}

variable "create_windows_password" {
  description = "Action for creation of Windows password or not using random string"
  type        = bool
  default     = false
}

#------------------------------------------------------------------------------------------
# Default variables
#------------------------------------------------------------------------------------------

variable "resource_group_name" {
  description = "(Required) The name of the resource group in which to create the Container Registry. Changing this forces a new resource to be created."
  type        = string
  default     = null
}

variable "location_name" {
  description = "(Required) Specifies the supported Azure location where the resource exists. Changing this forces a new resource to be created."
  type        = string
  default     = null
}

variable "tags" {
  description = "(Optional) A mapping of tags to assign to the resource. Use the map of {tag = value} format."
  type        = map(string)
  default     = {}
}

#------------------------------------------------------------------------------------------
# Virtual Machine variables
#------------------------------------------------------------------------------------------

variable "admin_name" {
  description = "The name of the administrator account for the VM."
  type        = string
  default     = null
}

variable "admin_password" {
  description = "The password associated with the admin_name account."
  type        = string
  default     = null
  sensitive   = true
}

variable "admin_ssh_key" {
  description = "The SSH public key associated with the admin_name account."
  type        = string
  default     = null
}

variable "vm_sku" {
  description = "The size of the VM."
  type        = string
  default     = null
}

variable "vm_name" {
  description = "The name of the VM."
  type        = string
  default     = null
}

variable "zone" {
  description = "The availability zone in which the VM should be created."
  type        = string
  default     = null
}

variable "network_interfaces" {
  description = "A list of network interface IDs to attach to the VM."
  type = map(object({
    rg_name                       = optional(string)
    vnet_name                     = string
    subnet_name                   = string
    private_ip                    = optional(string)
    allocation                    = optional(string)
    version                       = optional(string)
    enable_accelerated_networking = optional(bool)
    enable_ip_forwarding          = optional(bool)
    dns_servers                   = optional(list(string))
  }))
  default = null
}

variable "proximity_group" {
  description = "The ID of the Proximity Placement Group to use for the VM."
  type        = string
  default     = null
}

variable "computer_name" {
  description = "The computer name of the VM. If not specified, the VM name will be used as the computer name."
  type        = string
  default     = null
}

variable "license_type" {
  description = "Specifies the type of license that will be applied to the VM. Possible values are RHEL_BYOS and SLES_BYOS for Linux VMs. Possible values are None, Windows_Client and Windows_Server for Windows VMs."
  type        = string
  default     = null
}

variable "os_disk" {
  description = "A os_disk block as defined below."
  type = object({
    caching           = optional(string)
    disk_size_gb      = number
    name              = optional(string)
    sku               = optional(string) # Standard_LRS, StandardSSD_LRS, Premium_LRS, StandardSSD_ZRS, Premium_ZRS
    write_accelerator = optional(string)
  })
  default = null

  validation {
    condition     = var.os_disk.sku == null || var.os_disk.sku == "Standard_LRS" || var.os_disk.sku == "StandardSSD_LRS" || var.os_disk.sku == "Premium_LRS" || var.os_disk.sku == "StandardSSD_ZRS" || var.os_disk.sku == "Premium_ZRS"
    error_message = "The SKU of the OS disk must be Standard_LRS, StandardSSD_LRS, Premium_LRS, StandardSSD_ZRS or Premium_ZRS."
  }
}

variable "os_image_reference" {
  description = "Information of the OS image to use for the VM. This can be specified instead of a `source_image_id` to reference a published image in the Azure Marketplace. The `offer`, `publisher`, `sku` and `version` can be found by running `az vm image list` or in the Azure Portal. The `version` can be omitted to use the latest version."
  type = object({
    publisher = string
    offer     = string
    sku       = string
    version   = string
  })
  default = null
}

variable "os_image_id" {
  description = "The ID of a custom image to use for the VM. This can be specified instead of a `os_source_image` to reference a custom image."
  type        = string
  default     = null
}

variable "boot_diagnostics" {
  description = "Enable or disable boot diagnostics. It will use only Managed Storage Account."
  type        = bool
  default     = null
}

variable "data_disks" {
  description = "A list of data disks to attach to the VM. Use the Key for LUN number and all the other values for the disk configuration."
  type = map(object({
    name              = optional(string)
    size              = number
    storage_type      = optional(string)
    create_option     = optional(string)
    caching           = optional(string)
    write_accelerator = optional(bool)
  }))
  default = null
}

variable "windows_password" {
  description = "The password for administrator account of the Windows VM."
  type        = string
  default     = null
}
