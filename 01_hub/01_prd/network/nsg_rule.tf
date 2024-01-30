# ===============================================================================
#  Hub Zone
# ===============================================================================
# 1@ trusted subnet nsg rule
module "hub_trusted_nsg" {
  depends_on = [
    azurerm_resource_group.hub_rg
  ]
  source              = "../../../modules/azure/network_security_group"
  name                = var.hub_trusted_nsg_name
  resource_group_name = azurerm_resource_group.hub_rg.name
  location            = azurerm_resource_group.hub_rg.location
  tags                = var.tags

  security_rules = {
    in-rule01 = {
      name                       = "inbound_rule-001"
      description                = "rule"
      priority                   = "1000"
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "8080"
      source_address_prefix      = "*"
      destination_address_prefix = "*"
    },
    in-rule02 = {
      name                       = "inbound_rule-002"
      description                = "rule"
      priority                   = "1100"
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "9090"
      source_address_prefix      = "*"
      destination_address_prefix = "*"
    }
  }
}

# 2@ untrusted subnet nsg rule
module "hub_untrusted_nsg" {
  depends_on = [
    azurerm_resource_group.hub_rg
  ]
  source              = "../../../modules/azure/network_security_group"
  name                = var.hub_untrusted_nsg_name
  resource_group_name = azurerm_resource_group.hub_rg.name
  location            = azurerm_resource_group.hub_rg.location
  tags                = var.tags

  security_rules = {
    in-rule01 = {
      name                       = "inbound_rule-001"
      description                = "rule"
      priority                   = "1000"
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "8080"
      source_address_prefix      = "*"
      destination_address_prefix = "*"
    },
    in-rule02 = {
      name                       = "inbound_rule-003"
      description                = "rule"
      priority                   = "1100"
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "9090"
      source_address_prefix      = "*"
      destination_address_prefix = "*"
    }
  }
}

# 3@ mgmt subnet nsg rule
module "hub_mgmt_nsg" {
  depends_on = [
    azurerm_resource_group.hub_rg
  ]
  source              = "../../../modules/azure/network_security_group"
  name                = var.hub_mgmt_nsg_name
  resource_group_name = azurerm_resource_group.hub_rg.name
  location            = azurerm_resource_group.hub_rg.location
  tags                = var.tags

  security_rules = {
    in-rule01 = {
      name                       = "inbound_rule-001"
      description                = "rule"
      priority                   = "1000"
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "3389"
      source_address_prefix      = "*"
      destination_address_prefix = "*"
    },
    in-rule02 = {
      name                       = "inbound_rule-002"
      description                = "rule"
      priority                   = "1100"
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "22"
      source_address_prefix      = "*"
      destination_address_prefix = "*"
    }
  }
}
