data "azurerm_subnet" "untrusted" {
  name                 = "smp-untrusted-subnet"
  virtual_network_name = "smp-hub-001-vnet"
  resource_group_name  = var.hub_network_resource_group_name
}

data "azurerm_subnet" "trusted" {
  name                 = "smp-trusted-subnet"
  virtual_network_name = "smp-hub-001-vnet"
  resource_group_name  = var.hub_network_resource_group_name
}

data "azurerm_network_interface" "nic" {
  depends_on          = [module.fw-linux-vm-01, module.fw-linux-vm-02]
  for_each            = toset(var.network_interfaces)
  name                = each.value
  resource_group_name = azurerm_resource_group.fw_rg.name
}

data "azurerm_resource_group" "hub_rg" {
  name = var.hub_network_resource_group_name
}

data "azurerm_virtual_network" "vnet" {
  name                = var.virtual_network_name
  resource_group_name = data.azurerm_resource_group.hub_rg.name
}

data "azurerm_subnet" "untrusted_subnet" {
  name                 = var.untrusted_subnet_name
  virtual_network_name = data.azurerm_virtual_network.vnet.name
  resource_group_name  = data.azurerm_resource_group.hub_rg.name
}

data "azurerm_subnet" "trusted_subnet" {
  name                 = var.trusted_subnet_name
  virtual_network_name = data.azurerm_virtual_network.vnet.name
  resource_group_name  = data.azurerm_resource_group.hub_rg.name
}
