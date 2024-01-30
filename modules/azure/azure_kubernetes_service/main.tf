resource "tls_private_key" "ssh" {
  count     = var.admin_username == null ? 0 : 1
  algorithm = "RSA"
  rsa_bits  = 2048
}


resource "azurerm_kubernetes_cluster" "cluster" {
  name                = var.aks_name
  resource_group_name = var.resource_group_name
  location            = var.location
  kubernetes_version  = var.kubernetes_version
  dns_prefix          = var.dns_prefix
  # api_server_authorized_ip_ranges = each.value.api_server_authorized_ip_ranges
  azure_policy_enabled = var.policy_enabled
  node_resource_group  = var.node_resource_group
  //실제 클러스터 API 서버가 내부 IP 주소에만 노출되고 클러스터 vnet에서만 사용 가능한 경우
  private_cluster_enabled = var.private_cluster_enabled
  // private 클러스터에 대한 public fqdn 을 추가 해야하는 여부 지정 , default 는 false
  private_cluster_public_fqdn_enabled = var.private_cluster_public_fqdn_enabled
  // 이 클러스터에 위임해야 하는 프라이빗 DNS 영역의 ID , None'의 경우 자체 DNS 서버를 가져와 해결을 설정
  private_dns_zone_id               = var.private_dns_zone_id
  role_based_access_control_enabled = var.role_based_access_control_enabled
  sku_tier                          = var.sku_tier

  default_node_pool {
    name                  = var.default_node_pool_name
    vm_size               = var.default_node_vm_size
    enable_auto_scaling   = var.enable_auto_scaling
    node_count            = var.node_count
    min_count             = (var.enable_auto_scaling == true ? var.min_count : null)
    max_count             = var.max_count
    type                  = var.default_node_pool_type // AvailabilitySet and VirtualMachineScaleSets. Defaults to VirtualMachineScaleSets
    enable_node_public_ip = var.enable_node_public_ip
    vnet_subnet_id        = var.vnet_subnet_id
    zones                 = var.default_node_availability_zones
    max_pods              = var.max_pods
    os_disk_type          = var.os_disk_type //ossible values are `Ephemeral` and `Managed`
    os_disk_size_gb       = var.os_disk_size_gb
    pod_subnet_id         = var.pod_subnet_id
  }

  dynamic "network_profile" {
    for_each = (var.dns_service_ip != "" || var.docker_bridge_cidr != "" || var.service_cidr != "" ? ["plugin"] : [])
    content {
      network_plugin     = var.network_plugin
      dns_service_ip     = var.dns_service_ip
      docker_bridge_cidr = var.docker_bridge_cidr
      network_policy     = var.network_policy
      outbound_type      = var.outbound_type
      pod_cidr           = var.network_plugin == "kubenet" ? var.pod_cidr : null
      service_cidr       = var.service_cidr
    }
  }

  dynamic "network_profile" {
    for_each = (var.dns_service_ip == "" || var.docker_bridge_cidr == "" || var.service_cidr == "" ? ["plugin"] : [])
    content {
      network_plugin = var.network_plugin
      outbound_type  = var.outbound_type
      network_policy = var.network_policy
    }
  }

  identity {
    type = var.identity_type
  }

  dynamic "linux_profile" {
    for_each = var.admin_username == null ? [] : ["linux_profile"]

    content {
      admin_username = var.admin_username
      ssh_key {
        key_data = replace(coalesce(var.public_ssh_key, tls_private_key.ssh[0].public_key_openssh), "\n", "")
      }
    }
  }
}

resource "azurerm_kubernetes_cluster_node_pool" "nodepool" {
  depends_on            = [azurerm_kubernetes_cluster.cluster]
  for_each              = var.node_pools
  name                  = each.key
  kubernetes_cluster_id = azurerm_kubernetes_cluster.cluster.id
  vnet_subnet_id        = each.value.subnet_id
  vm_size               = each.value.vm_size

  enable_auto_scaling = each.value.enable_auto_scaling
  node_count          = each.value.node_count
  max_count           = each.value.max_count
  min_count           = (each.value.enable_auto_scaling == true ? each.value.min_count : null)

  kubelet_disk_type = each.value.kubelet_disk_type
  os_type           = each.value.os_type
  os_sku            = each.value.os_sku
  os_disk_type      = each.value.os_disk_type
  os_disk_size_gb   = each.value.os_disk_size_gb
}



