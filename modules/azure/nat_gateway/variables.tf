
variable "location" {
  type = string
}

variable "resource_group_name" {
  type = string
}

variable "nat-gateway" {
  type = map(object({
    #public_ip_prefix_length = number
    idle_timeout_in_minutes = number
    vnet_name               = string
    subnet_name             = string
    subnet_id               = string
  }))
}
