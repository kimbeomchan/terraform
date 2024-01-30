# Resource Group
variable "hub_network_resource_group_name" {
  description = "Specifies the resource group name"
  type        = string
  default     = "smp-hub-network-rg"
}

variable "hub_fw_resource_group_name" {
  type    = string
  default = "smp-hub-fw-rg"
}

# Location
variable "location" {
  description = "Specifies the location for the resource group and all the resources"
  type        = string
  default     = "koreacentral"
}

# vnet & subnet
variable "prd_vnet_name" {
  description = "Specifies the name of the hub virtual virtual network"
  default     = "prd-001-vnet"
  type        = string
}

variable "network_interfaces" {
  type    = list(string)
  default = ["hubfwlinux-vm-untrusted-nic-01", "hubfwlinux-vm-untrusted-nic-02"]
}

variable "virtual_network_name" {
  description = "The name of the virtual network"
  default     = "smp-hub-001-vnet"
}

variable "untrusted_subnet_name" {
  description = "The name of the subnet to use in VM scale set"
  default     = "smp-untrusted-subnet"
}

variable "trusted_subnet_name" {
  description = "The name of the subnet to use in VM scale set"
  default     = "smp-trusted-subnet"
}

variable "enable_vm_availability_set" {
  description = "Manages an Availability Set for Virtual Machines."
  default     = false
}

variable "platform_fault_domain_count" {
  description = "Specifies the number of fault domains that are used"
  default     = 2
}
variable "platform_update_domain_count" {
  description = "Specifies the number of update domains that are used"
  default     = 5
}

variable "virtual_machine_name" {
  description = "The name of the virtual machine."
  default     = ""
}

variable "instances_count" {
  description = "The number of Virtual Machines required."
  default     = 1
}

variable "admin_username" {
  description = "The username of the local administrator used for the Virtual Machine."
  default     = "azureadmin"
}

variable "admin_password" {
  description = "The Password which should be used for the local-administrator on this Virtual Machine"
  default     = null
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}

variable "nat-gateway" {
  default = {
    public_ip_prefix_length = null
    idle_timeout_in_minutes = null
    vnet_name               = null
    subnet_name             = null
    subnet_id               = null
  }
}
