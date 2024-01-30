data "azurerm_resource_group" "rg" {
  name = var.prd_spoke_rg
}

data "azurerm_virtual_network" "vnet" {
  name                = var.aks_vnet
  resource_group_name = data.azurerm_resource_group.rg.name
}

data "azurerm_subnet" "sub1" {
  name                 = var.aks_subnet1
  virtual_network_name = data.azurerm_virtual_network.vnet.name
  resource_group_name  = data.azurerm_resource_group.rg.name
}

data "azurerm_subnet" "sub2" {
  name                 = var.aks_subnet2
  virtual_network_name = data.azurerm_virtual_network.vnet.name
  resource_group_name  = data.azurerm_resource_group.rg.name
}


module "aks" {
  source                            = "../../../../modules/azure/azure_kubernetes_service"
  admin_username                    = var.admin_username
  resource_group_name               = data.azurerm_resource_group.rg.name
  location                          = data.azurerm_resource_group.rg.location
  aks_name                          = "smp-prd-aks-cluster"
  kubernetes_version                = "1.23.12"
  dns_prefix                        = "prefix"
  policy_enabled                    = true
  node_resource_group               = ""
  private_cluster_enabled           = true
  private_dns_zone_id               = null
  role_based_access_control_enabled = false
  identity_type                     = "SystemAssigned"

  //default_node_pool
  default_node_pool_name          = "defaultnode"
  default_node_vm_size            = "Standard_B4ms"
  enable_auto_scaling             = true
  default_node_availability_zones = [1, 2, 3]
  node_count                      = 1
  min_count                       = 1
  max_count                       = 2
  vnet_subnet_id                  = data.azurerm_subnet.sub1.id

  //network profile
  network_plugin     = "azure"
  network_policy     = "azure"
  dns_service_ip     = "10.1.0.10"
  docker_bridge_cidr = "172.17.0.1/16"
  service_cidr       = "10.1.0.0/24"

  //node pool
  # add_nodepool_enabled = "enabled"
  node_pools = {
    internal = {
      cluster_name        = "smp-prd-aks-cluster"
      subnet_id           = data.azurerm_subnet.sub2.id
      vm_size             = "Standard_DS2_v2"
      enable_auto_scaling = true
      node_count          = 2
      max_count           = 5
      min_count           = 2
      kubelet_disk_type   = "OS"
      os_type             = "Linux"
      os_sku              = "Ubuntu"
      os_disk_type        = "Managed"
      os_disk_size_gb     = 30

    }
  }
}

