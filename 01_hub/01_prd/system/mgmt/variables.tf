variable "hub_mgmt_resource_group_name" {
  description = "Specifies the resource group name"
  type        = string
  default     = "smp-hub-mgmt-rg"
}

variable "hub_network_resource_group_name" {
  description = "A container that holds related resources for an Azure solution"
  default     = "smp-hub-network-rg"
}

variable "location" {
  description = "The location/region to keep all your network resources. To get the list of all locations with table format from azure cli, run 'az account list-locations -o table'"
  default     = "koreacentral"
}

variable "virtual_network_name" {
  description = "The name of the virtual network"
  default     = "smp-hub-001-vnet"
}

variable "subnet_name" {
  description = "The name of the subnet to use in VM scale set"
  default     = "smp-mgmt-subnet"
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
