resource "azurerm_resource_group" "mgmt_rg" {
  name     = var.hub_mgmt_resource_group_name
  location = var.location
  tags     = var.tags
}

module "mgmt-linux-vm" {
  depends_on = [
    azurerm_resource_group.mgmt_rg
  ]

  source               = "../../../../modules/azure/virtual_machine"
  virtual_machine_name = "hubmgmtlinuxvm"
  resource_group_name  = azurerm_resource_group.mgmt_rg.name
  location             = var.location
  virtual_network_name = data.azurerm_virtual_network.vnet.name
  subnet_name          = data.azurerm_subnet.subnet.name
  tags                 = var.tags

  network_interfaces = [
    {
      name        = "hubmgmtlinux-vm-nic-01",
      subnet_name = data.azurerm_subnet.subnet.name,
      subnet_id   = data.azurerm_subnet.subnet.id
    }
  ]

  # 이 모듈은 Linux 및 Windows 배포판을 미리 정의해놓고 사용함
  # gen2 배포판 사용 시, gen2 이미지가 지원되는 VM 크기를 사용해야함
  # 비밀번호 사용 시, "disable_password_authentication = false"로 사용
  # "admin_password" 인수로 비밀번호 기입
  # SSH 키 쌍 생성 시, "generate_admin_ssh_key = true"로 지정
  # 기존 키 쌍 사용 시, "admin_ssh_key_data"를 SSH 공개키 경로로 지정
  os_flavor            = "linux"
  virtual_machine_size = "Standard_B2s"
  instances_count      = 1
  vm_availability_zone = 1

  # 로그인 옵션
  # (옵션1) Password 사용 시
  disable_password_authentication = false
  admin_username                  = "azureadmin"
  admin_password                  = "Password1234!"

  # (옵션2) SSH Key 사용 시
  # SSH 키 쌍 생성하지 않고 경로 지정해서도 가능
  /* disable_password_authentication = true
  generate_admin_ssh_key          = false
  admin_username                  = "azureadmin"
  admin_ssh_key_data              = "~/.ssh/id_rsa.pub" */
  /* generate_admin_ssh_key          = true */

  # 이미지 옵션
  # (옵션1) 기존 제공해주는 이미지 사용 시
  /* linux_distribution_name = "ubuntu2004" */

  # (옵션2) 마켓플레이스 이미지 사용 시 `plan_name`, `plan_product`, `plan_publisher`에 대한 정보를 기입
  linux_distribution_name = "rocky86free"
  plan_name               = "free"
  plan_product            = "rockylinux"
  plan_publisher          = "erockyenterprisesoftwarefoundationinc1653071250513"

  /* admin_ssh_key {
    username   = "azureadmin"
    public_key = tls_private_key.example_ssh.public_key_openssh
  } */

  # (선택) 프록시 배치 그룹, 가용성 집합 및 공용 IP
  enable_proximity_placement_group = false
  enable_vm_availability_set       = false
  enable_public_ip_address         = true

  # 가상머신의 트러블 슈팅을 위해 사용
  # 커스텀한 스토리지 어카운트 사용을 위해서는 "storage_account_name" 추가 기입 필요 (Enable with custom storage account)
  # "true" =>  Enable with managed storage account (recommended)
  # "false" => Disable
  enable_boot_diagnostics = true

  # 위도우, 리눅스 가상머신에 managed data disk 연결
  # 스토리지 어카운트 타입: `Standard_LRS`, `StandardSSD_ZRS`, `Premium_LRS`, `Premium_ZRS`, `StandardSSD_LRS`
  # 새로운 data disk를 할당한 뒤, 가상머신과 연결하거나 diskmanagement 또는 fdisk 구성 필요
  data_disks = [
    {
      name                 = "disk1"
      disk_size_gb         = 100
      storage_account_type = "StandardSSD_LRS"
    },
    {
      name                 = "disk2"
      disk_size_gb         = 200
      storage_account_type = "Standard_LRS"
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

module "mgmt-windows-vm" {
  depends_on = [
    azurerm_resource_group.mgmt_rg
  ]

  source               = "../../../../modules/azure/virtual_machine"
  virtual_machine_name = "hubmgmtwinsvm"
  resource_group_name  = azurerm_resource_group.mgmt_rg.name
  location             = var.location
  virtual_network_name = data.azurerm_virtual_network.vnet.name
  subnet_name          = data.azurerm_subnet.subnet.name
  tags                 = var.tags

  network_interfaces = [
    {
      name        = "hubmgmtwins-vm-nic-01",
      subnet_name = data.azurerm_subnet.subnet.name,
      subnet_id   = data.azurerm_subnet.subnet.id
    }
  ]

  # 이 모듈은 Linux 및 Windows 배포판을 미리 정의해놓고 사용함
  # gen2 배포판 사용 시, gen2 이미지가 지원되는 VM 크기를 사용해야함
  # 비밀번호 사용 시, "disable_password_authentication = false"로 사용
  # "admin_password" 인수로 비밀번호 기입
  # SSH 키 쌍 생성 시, "generate_admin_ssh_key = true"로 지정
  # 기존 키 쌍 사용 시, "admin_ssh_key_data"를 SSH 공개키 경로로 지정
  os_flavor                       = "windows"
  windows_distribution_name       = "windows2019dc"
  enable_automatic_updates        = true
  patch_mode                      = "AutomaticByOS"
  virtual_machine_size            = "Standard_B2s"
  instances_count                 = 1
  vm_availability_zone            = 2
  disable_password_authentication = false
  admin_username                  = "azureadmin"
  admin_password                  = "Password1234!"
  vm_time_zone                    = "Korea Standard Time"

  # (선택) 프록시 배치 그룹, 가용성 집합 및 공용 IP
  enable_proximity_placement_group = false
  enable_vm_availability_set       = false
  enable_public_ip_address         = true

  # 가상머신의 트러블 슈팅을 위해 사용
  # 커스텀한 스토리지 어카운트 사용을 위해서는 "storage_account_name" 추가 기입 필요 (Enable with custom storage account)
  # "true" =>  Enable with managed storage account (recommended)
  # "false" => Disable
  enable_boot_diagnostics = true

  # 위도우, 리눅스 가상머신에 managed data disk 연결
  # 스토리지 어카운트 타입: `Standard_LRS`, `StandardSSD_ZRS`, `Premium_LRS`, `Premium_ZRS`, `StandardSSD_LRS`
  # 새로운 data disk를 할당한 뒤, 가상머신과 연결하거나 diskmanagement 또는 fdisk 구성 필요
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
