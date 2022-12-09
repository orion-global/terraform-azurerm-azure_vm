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

variable "zones" {
  description = "The availability zone in which the VM should be created."
  type        = string
  default     = null
}

variable "network_interfaces" {
  description = "A list of network interface IDs to attach to the VM."
  type = map(object({
    rg_name     = string
    vnet_name   = string
    subnet_name = string
  }))
  default = null
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
    caching                          = optional(string)
    sku                              = optional(string) # Standard_LRS, StandardSSD_LRS, Premium_LRS, StandardSSD_ZRS, Premium_ZRS
    disk_encryption_set_id           = optional(string)
    disk_size_gb                     = number
    name                             = optional(string)
    secure_vm_disk_encryption_set_id = optional(string)
    security_encryption_type         = optional(string)
    write_accelerator_enabled        = optional(string)
  })
  default = null

  validation {
    condition     = var.os_disk.sku == "Standard_LRS" || var.os_disk.sku == "StandardSSD_LRS" || var.os_disk.sku == "Premium_LRS" || var.os_disk.sku == "StandardSSD_ZRS" || var.os_disk.sku == "Premium_ZRS"
    error_message = "The SKU of the OS disk must be Standard_LRS, StandardSSD_LRS, Premium_LRS, StandardSSD_ZRS or Premium_ZRS."
  }
}
