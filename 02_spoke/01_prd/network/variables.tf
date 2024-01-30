variable "hub_network_resource_group_name" {
  description = "Specifies the resource group name"
  type        = string
  default     = "smp-hub-network-rg"
}

variable "virtual_network_name" {
  description = "The name of the virtual network"
  default     = "smp-hub-001-vnet"
}

variable "spoke_network_resource_group_name" {
  description = "Specifies the resource group name"
  type        = string
  default     = "smp-spoke-001-network-rg"
}

variable "location" {
  description = "Specifies the location for the resource group and all the resources"
  type        = string
  default     = "koreacentral"
}

variable "tags" {
  description = "(Optional) Specifies the tags of the storage account"
  default     = {}
}
