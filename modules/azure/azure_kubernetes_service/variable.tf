variable "admin_username" {
  type    = string
  default = null
}

variable "public_ssh_key" {
  type    = string
  default = ""
}

#-------------------------------
//aks cluster 

variable "aks_name" {
  type = string
}

variable "resource_group_name" {
  type = string
}

variable "location" {
  type = string
}

variable "kubernetes_version" {
  type = string
}

variable "dns_prefix" {
  type = string
}

variable "policy_enabled" {
  type = bool
}

variable "node_resource_group" {
  type = string
}

variable "private_cluster_enabled" {
  type    = bool
  default = false
}

variable "private_cluster_public_fqdn_enabled" {
  type    = bool
  default = true
}

variable "private_dns_zone_id" {
  type = string
}

variable "role_based_access_control_enabled" {
  type = bool
}

variable "sku_tier" {
  type    = string
  default = "Free"
}

variable "identity_type" {
  type = string
}


#-------------------------------------------
// default node pool

variable "default_node_pool_name" {
  type = string
}

variable "default_node_vm_size" {
  type = string
}

variable "enable_auto_scaling" {
  type    = bool
  default = null
}

variable "min_count" {
  type = number
}

variable "max_count" {
  type = number
}

variable "default_node_pool_type" {
  type    = string
  default = "VirtualMachineScaleSets"
}

variable "enable_node_public_ip" {
  type    = bool
  default = false
}

variable "vnet_subnet_id" {
  type    = string
  default = null
}

variable "default_node_availability_zones" {
  type = list(string)
}

variable "max_pods" {
  type    = number
  default = null
}

variable "os_disk_type" {
  type    = string
  default = "Managed"

}

variable "os_disk_size_gb" {
  type    = number
  default = null
}

variable "pod_subnet_id" {
  type    = string
  default = null
}

variable "node_count" {
  type = number
}

# ----------------------------------------
// network profile


variable "network_plugin" {
  type = string
}

variable "dns_service_ip" {
  type    = string
  default = ""
}

variable "docker_bridge_cidr" {
  type    = string
  default = ""
}

variable "service_cidr" {
  type    = string
  default = ""
}

variable "network_policy" {
  type = string
}

variable "outbound_type" {
  type    = string
  default = "loadBalancer"
}


variable "pod_cidr" {
  type    = string
  default = null
}

# --------------------------------------
// add node pool

variable "node_pools" {
  type = map(object({
    subnet_id           = string
    vm_size             = string
    enable_auto_scaling = bool
    node_count          = number
    max_count           = number
    min_count           = number
    kubelet_disk_type   = string
    os_type             = string
    os_sku              = string
    os_disk_type        = string
    os_disk_size_gb     = number
  }))
  default = {}
}
