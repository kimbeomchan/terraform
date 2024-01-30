data "azurerm_resource_group" "hub_rg" {
  provider = azurerm.prd-subs
  name     = var.hub_network_resource_group_name
}

data "azurerm_virtual_network" "vnet" {
  provider            = azurerm.prd-subs
  name                = var.virtual_network_name
  resource_group_name = data.azurerm_resource_group.hub_rg.name
}
