# Resource Group
variable "prd_spoke_rg" {
  type    = string
  default = "smp-spoke-001-network-rg"
}

variable "aks_vnet" {
  type    = string
  default = "smp-spoke-001-vnet"
}

variable "aks_subnet1" {
  type    = string
  default = "smp-aks-node01-subnet"
}

variable "aks_subnet2" {
  type    = string
  default = "smp-aks-node02-subnet"

}
variable "admin_username" {
  type    = string
  default = "azureadmin"
}
