variable "resource_group_name" {
  type = string
}

variable "location" {
  type = string
}

variable "lb_name" {
  type = string
}

variable "allocate_public_ip" {
  type = string
}

variable "pip_allocation_method" {
  type    = string
  default = ""
}

variable "pip_name" {
  type    = string
  default = ""
}

variable "fip_name" {
  type = string
}

variable "pip_sku" {
  type    = string
  default = ""
}

variable "sku" {
  type    = string
  default = "Basic"
}

variable "private_ip_address" {
  type    = string
  default = ""
}

variable "private_ip_address_allocation" {
  type    = string
  default = ""
}

variable "subnet_id" {
  type    = string
  default = ""
}

variable "lb_frontend_ip_configurations" {
  type = map(object({
    subnet_id = string

    zones = optional(list(number))

    private_ip_address            = optional(string)
    private_ip_address_allocation = optional(string, "Dynamic")
    private_ip_address_version    = optional(string, "IPv4")

    public_ip_address_id = optional(string)
    public_ip_prefix_id  = optional(string)

    gateway_load_balancer_frontend_ip_configuration_id = optional(string)
  }))
  default = {}
}

variable "lb_back_pools" {
  type = map(object({
    backendpool_name = string
  }))
}

variable "nic_backend_asso" {
  type = map(object({
    backendpool_name = string
  }))
}

variable "lb_probes" {
  type = map(object({
    lb_probe_port       = number
    lb_probe_protocol   = string
    interval_in_seconds = number
  }))
}

variable "lb_rules" {
  type = map(object({
    lb_probe_name         = string
    lb_rule_protocol      = string
    lb_back_pool_name     = string
    lb_rule_frontend_port = number
    lb_rule_backend_port  = number
    enable_floating_ip    = bool
    disable_outbound_snat = bool
  }))
}
