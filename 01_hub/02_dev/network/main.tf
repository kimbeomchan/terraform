#----------------------------------------------------------
# Resource Group, VNet, Subnet selection & Random Resources
#----------------------------------------------------------

# Create Spoke Zone Network ResourceGroup
resource "azurerm_resource_group" "spoke_rg" {
  name     = var.spoke_network_resource_group_name
  location = var.location
  tags     = var.tags
}

# Create Spoke Zone Virtaul Network
module "vnet" {
  depends_on = [
    azurerm_resource_group.spoke_rg
  ]

  source              = "../../../modules/azure/virtual_network"
  vnet_name           = "smp-hub-002-vnet"
  resource_group_name = azurerm_resource_group.spoke_rg.name
  address_space       = ["10.100.0.0/16"]
  subnet_prefixes     = ["10.100.0.0/24", "10.100.1.0/24", "10.100.2.0/24"]
  subnet_names        = ["smp-trusted-dev-subnet", "smp-untrusted-dev-subnet", "smp-mgmt-dev-subnet"]
  vnet_location       = azurerm_resource_group.spoke_rg.location
  tags                = var.tags
}

# Virtual Network Peering Association
module "vnet_peering" {
  depends_on = [
    azurerm_resource_group.spoke_rg,
    module.vnet,
    data.azurerm_virtual_network.vnet
  ]

  providers = {
    azurerm.prd-subs = azurerm.prd-subs
  }

  source              = "../../../modules/azure/virtual_network_peering_subs"
  vnet_1_name         = "smp-hub-001-vnet"
  vnet_1_id           = data.azurerm_virtual_network.vnet.id
  vnet_1_rg           = data.azurerm_resource_group.hub_rg.name
  vnet_2_name         = "smp-hub-002-vnet"
  vnet_2_id           = module.vnet.vnet_id
  vnet_2_rg           = azurerm_resource_group.spoke_rg.name
  peering_name_1_to_2 = "hub_to_dev-hub"
  peering_name_2_to_1 = "dev-hub_to_hub"
}
