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
# Network variables
#------------------------------------------------------------------------------------------

variable "network_rg_name" {
  description = "Name of the resource group where the network is located"
  type        = string
  default     = null
}

variable "network_name" {
  description = "Name of the Virtual Network for the VM"
  type        = string
  default     = null
}

variable "subnet_name" {
  description = "Name of the Subnet for the VM. Must be part of the network_name"
  type        = string
  default     = null
}

#------------------------------------------------------------------------------------------
# Virtual Machine variables
#------------------------------------------------------------------------------------------

variable "admin_name" {
  description = "The name of the administrator account for the VM."
  type        = string
  default     = null
}

variable "vm_size" {
  description = "The size of the VM."
  type        = string
  default     = null
}

variable "vm_name" {
  description = "The name of the VM."
  type        = string
  default     = null
}

variable "network_interfaces" {
  description = "A list of network interface IDs to attach to the VM."
  type = map(object({
    enable_zone_redundancy   = bool
    enable_regional_endpoint = bool
  }))
  default = null
}
