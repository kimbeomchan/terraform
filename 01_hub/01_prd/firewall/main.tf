######################################################
## 본 모듈은 샘플 용도로 이미지는 Linux Image로 구성하였습니다. ##
######################################################

resource "azurerm_resource_group" "fw_rg" {
  name     = var.hub_fw_resource_group_name
  location = var.location
  tags     = var.tags
}

# Create Firewall Virtual Machine 01
module "fw-linux-vm-01" {
  depends_on = [
    azurerm_resource_group.fw_rg
  ]

  source               = "../../../modules/azure/virtual_machine"
  virtual_machine_name = "hubfwlinux-vm-01"
  resource_group_name  = azurerm_resource_group.fw_rg.name
  location             = var.location
  virtual_network_name = data.azurerm_virtual_network.vnet.name
  tags                 = var.tags

  ## Network Interface의 이름, 연결 할 Subnet 이름 및 ID 값을 작성
  network_interfaces = [
    {
      name        = "hubfwlinux-vm-untrusted-nic-01",
      subnet_name = var.untrusted_subnet_name,
      subnet_id   = data.azurerm_subnet.untrusted_subnet.id
    },
    {
      name        = "hubfwlinux-vm-trusted-nic-01",
      subnet_name = var.trusted_subnet_name,
      subnet_id   = data.azurerm_subnet.trusted_subnet.id
    }
  ]

  os_flavor                       = "linux"
  linux_distribution_name         = "ubuntu2004"
  virtual_machine_size            = "Standard_B2s"
  admin_username                  = "azureuser"
  disable_password_authentication = true
  generate_admin_ssh_key          = true
  instances_count                 = 1
  vm_availability_zone            = 1

  # (선택) 프록시 배치 그룹, 가용성 집합 및 공용 IP
  enable_proximity_placement_group = false
  enable_vm_availability_set       = false
  enable_public_ip_address         = false
  enable_boot_diagnostics          = true

  data_disks = [
    {
      name                 = "disk1"
      disk_size_gb         = 100
      storage_account_type = "StandardSSD_LRS"
    }
  ]

  # (선택) 애저 모니터링 활성화와 로그 어날리틱스 에이전트 설치 시 사용
  # (선택) 모니터링 로그를 스토리지 어카운트에 저장하려면 "storage_account_name" 추가 기입 필요
  /* log_analytics_workspace_id = data.azurerm_log_analytics_workspace.example.id */

  # 로그 어날리틱스 에이전트를 가상머신에 배포 시 "true" 
  # 로그 어날리틱스 워크스페이스 "customer is"와 "primary shared key"가 요구됨
  /* deploy_log_analytics_agent                 = false */
  /* log_analytics_customer_id                  = data.azurerm_log_analytics_workspace.example.workspace_id */
  /* log_analytics_workspace_primary_shared_key = data.azurerm_log_analytics_workspace.example.primary_shared_key */
}

# Create Firewall Virtual Machine 02
module "fw-linux-vm-02" {
  depends_on = [
    azurerm_resource_group.fw_rg
  ]

  source               = "../../../modules/azure/virtual_machine"
  virtual_machine_name = "hubfwlinux-vm-02"
  resource_group_name  = azurerm_resource_group.fw_rg.name
  location             = var.location
  virtual_network_name = data.azurerm_virtual_network.vnet.name
  tags                 = var.tags

  network_interfaces = [
    {
      name        = "hubfwlinux-vm-untrusted-nic-02",
      subnet_name = var.untrusted_subnet_name,
      subnet_id   = data.azurerm_subnet.untrusted_subnet.id
    },
    {
      name        = "hubfwlinux-vm-trusted-nic-02",
      subnet_name = var.trusted_subnet_name,
      subnet_id   = data.azurerm_subnet.trusted_subnet.id
    }
  ]

  os_flavor                       = "linux"
  linux_distribution_name         = "ubuntu2004"
  virtual_machine_size            = "Standard_B2s"
  admin_username                  = "azureuser"
  disable_password_authentication = true
  generate_admin_ssh_key          = true
  instances_count                 = 1
  vm_availability_zone            = 1

  enable_proximity_placement_group = false
  enable_vm_availability_set       = false
  enable_public_ip_address         = false
  enable_boot_diagnostics          = true

  data_disks = [
    {
      name                 = "disk1"
      disk_size_gb         = 100
      storage_account_type = "StandardSSD_LRS"
    }
  ]
}


# Create NAT Gateway
module "nat_gateway" {
  source              = "../../../modules/azure/nat_gateway"
  resource_group_name = azurerm_resource_group.fw_rg.name
  location            = var.location
  nat-gateway = {
    nat-Gateway01 = {
      #public_ip_prefix_length = null
      idle_timeout_in_minutes = 10
      vnet_name               = "smp-hub-001-vnet"
      subnet_name             = "smp-untrusted-subnet"
      subnet_id               = data.azurerm_subnet.untrusted.id
    }
  }
}

# Create External Load Balancer
module "elb" {
  depends_on            = [module.fw-linux-vm-01, module.fw-linux-vm-02]
  source                = "../../../modules/azure/load_balancer"
  resource_group_name   = azurerm_resource_group.fw_rg.name
  location              = var.location
  allocate_public_ip    = true
  lb_name               = "smp-hub-001-elb"
  pip_allocation_method = "Static"
  pip_name              = "smp-pip-lb"
  fip_name              = "smp-fip-lb"
  pip_sku               = "Standard"

  # LB Backend pool
  lb_back_pools = {
    smp-elb-001-bep = {
      backendpool_name = "smp-elb-001-bep"
    }
  }

  # NIC & Backend address pool Association
  nic_backend_asso = {
    hubfwlinux-vm-untrusted-nic-01 = {
      backendpool_name = "smp-elb-001-bep"
    }
    hubfwlinux-vm-untrusted-nic-02 = {
      backendpool_name = "smp-elb-001-bep"
    }
  }

  # LB Probes
  lb_probes = {
    smp-elb-001-probe = {
      lb_probe_port       = 80
      lb_probe_protocol   = "Tcp"
      interval_in_seconds = 15
    }
  }

  # LB Rules
  lb_rules = {
    test-elb-rule = {
      lb_back_pool_name     = "smp-elb-001-bep"
      lb_probe_name         = "smp-elb-001-probe"
      lb_rule_protocol      = "Tcp"
      lb_rule_frontend_port = 80
      lb_rule_backend_port  = 80
      enable_floating_ip    = true
      disable_outbound_snat = true
    }
  }
}

module "ilb" {
  depends_on                    = [module.fw-linux-vm-01, module.fw-linux-vm-02]
  source                        = "../../../modules/azure/load_balancer"
  resource_group_name           = azurerm_resource_group.fw_rg.name
  location                      = var.location
  lb_name                       = "smp-hub-001-ilb"
  allocate_public_ip            = false
  private_ip_address_allocation = "Static"
  private_ip_address            = "10.0.0.11"
  subnet_id                     = data.azurerm_subnet.trusted.id
  fip_name                      = "smp-fip-ilb"

  # LB Backend pool
  lb_back_pools = {
    smp-ilb-001-bep = {
      backendpool_name = "smp-ilb-001-bep"
    }
  }

  # NIC & Backend address pool Association
  nic_backend_asso = {
    hubfwlinux-vm-trusted-nic-01 = {
      backendpool_name = "smp-ilb-001-bep"
    }
    hubfwlinux-vm-trusted-nic-02 = {
      backendpool_name = "smp-ilb-001-bep"
    }
  }

  # LB Probes
  lb_probes = {
    smp-ilb-001-probe = {
      lb_probe_port       = 80
      lb_probe_protocol   = "Tcp"
      interval_in_seconds = 15
    }
  }

  # LB Rules
  lb_rules = {
    test-lb-rule = {
      lb_back_pool_name     = "smp-ilb-001-bep"
      lb_probe_name         = "smp-ilb-001-probe"
      lb_rule_protocol      = "Tcp"
      lb_rule_frontend_port = 80
      lb_rule_backend_port  = 80
      enable_floating_ip    = true
      disable_outbound_snat = true
    }
  }
}

