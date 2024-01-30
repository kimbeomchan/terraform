variable "name" {
  description = "(Required) Specifies the name of the route table"
  type        = string
}

variable "resource_group_name" {
  description = "(Required) Specifies the resource group name of the route table"
  type        = string
}

variable "location" {
  description = "(Required) Specifies the location of the route table"
  type        = string
}

variable "rt_rules" {
  description = "(Optional) Specifies the security rules of the route table"
  type = map(object({
      name                   = string
      address_prefix         = string
      next_hop_type          = string
      next_hop_in_ip_address = string
  }))
}

variable "tags" {
  description = "(Optional) Specifies the tags of the network security group"
  default     = {}
}