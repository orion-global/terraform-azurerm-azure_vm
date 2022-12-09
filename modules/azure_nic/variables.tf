#------------------------------------------------------------------------------------------
# Default variables
#------------------------------------------------------------------------------------------

variable "location_name" {
  description = "The Azure location where all resources in this example should be created."
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

variable "resource_group_name" {
  description = "Name of the resource group where the NIC will be created"
  type        = string
  default     = null
}

variable "nic_name" {
  description = "Name of the NIC to be created"
  type        = string
  default     = null
}

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

variable "enable_accelerated_networking" {
  description = "Enable or disable accelerated networking"
  type        = bool
  default     = false
}

variable "enable_ip_forwarding" {
  description = "Enable or disable IP forwarding"
  type        = bool
  default     = false
}
