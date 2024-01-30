# ===============================================================================
#  Hub Zone
# ===============================================================================
# 1@ trusted subnet udr rule
module "hub_trusted_rt" {
  depends_on = [
    azurerm_resource_group.hub_rg
  ]
  source              = "../../../modules/azure/route_table"
  name                = var.hub_trusted_rt_name
  resource_group_name = azurerm_resource_group.hub_rg.name
  location            = azurerm_resource_group.hub_rg.location
  tags                = var.tags

  rt_rules = {
    in-rule01 = {
      name                   = "trustrt-01"
      address_prefix         = "0.0.0.0/0"
      next_hop_in_ip_address = "10.0.1.4"
      next_hop_type          = "VirtualAppliance"
    },
    in-rule02 = {
      name                   = "trustrt-02"
      address_prefix         = "10.0.1.0/24"
      next_hop_in_ip_address = "10.0.1.5"
      next_hop_type          = "VirtualAppliance"
    }
  }
}

# 1@ trusted subnet udr rule
module "hub_untrusted_rt" {
  depends_on = [
    azurerm_resource_group.hub_rg
  ]
  source              = "../../../modules/azure/route_table"
  name                = var.hub_untrusted_rt_name
  resource_group_name = azurerm_resource_group.hub_rg.name
  location            = azurerm_resource_group.hub_rg.location
  tags                = var.tags

  rt_rules = {
    in-rule01 = {
      name                   = "trustrt-01"
      address_prefix         = "0.0.0.0/0"
      next_hop_in_ip_address = "10.0.1.4"
      next_hop_type          = "VirtualAppliance"
    },
    in-rule02 = {
      name                   = "trustrt-02"
      address_prefix         = "10.0.1.0/24"
      next_hop_in_ip_address = "10.0.1.5"
      next_hop_type          = "VirtualAppliance"
    }
  }
}

# 1@ trusted subnet udr rule
module "hub_mgmt_rt" {
  depends_on = [
    azurerm_resource_group.hub_rg
  ]
  source              = "../../../modules/azure/route_table"
  name                = var.hub_mgmt_rt_name
  resource_group_name = azurerm_resource_group.hub_rg.name
  location            = azurerm_resource_group.hub_rg.location
  tags                = var.tags

  rt_rules = {
    in-rule01 = {
      name                   = "trustrt-01"
      address_prefix         = "0.0.0.0/0"
      next_hop_in_ip_address = "10.0.1.4"
      next_hop_type          = "VirtualAppliance"
    },
    in-rule02 = {
      name                   = "trustrt-02"
      address_prefix         = "10.0.1.0/24"
      next_hop_in_ip_address = "10.0.1.5"
      next_hop_type          = "VirtualAppliance"
    }
  }
}
