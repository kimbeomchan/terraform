# Create Hub Zone Network ResourceGroup
resource "azurerm_resource_group" "hub_rg" {
  name     = var.hub_network_resource_group_name
  location = var.location
  tags     = var.tags
}

# Create Hub Zone Virtaul Network
module "vnet" {
  depends_on          = [azurerm_resource_group.hub_rg]
  source              = "../../../modules/azure/virtual_network"
  vnet_name           = "smp-hub-001-vnet"
  resource_group_name = azurerm_resource_group.hub_rg.name
  address_space       = ["20.0.0.0/16"]
  subnet_prefixes     = ["20.0.0.0/24", "20.0.1.0/24", "20.0.2.0/24"]
  subnet_names        = ["smp-trusted-subnet", "smp-untrusted-subnet", "smp-mgmt-subnet"]
  vnet_location       = azurerm_resource_group.hub_rg.location
  tags                = var.tags

  # nsgs association
  nsg_ids = {
    smp-trusted-subnet   = module.hub_trusted_nsg.id
    smp-untrusted-subnet = module.hub_untrusted_nsg.id
    smp-mgmt-subnet      = module.hub_mgmt_nsg.id
  }

  # udr association
  route_tables_ids = {
    smp-trusted-subnet   = module.hub_trusted_rt.id
    smp-untrusted-subnet = module.hub_untrusted_rt.id
    smp-mgmt-subnet      = module.hub_mgmt_rt.id
  }

  # (option) subnet service endpoint
  subnet_service_endpoints = {
    smp-trusted-subnet   = ["Microsoft.Storage", "Microsoft.Sql"],
    smp-untrusted-subnet = ["Microsoft.AzureActiveDirectory"]
  }

  # (option) sutnet delegation
  subnet_delegation = {
    smp-untrusted-subnet = {
      "Microsoft.Sql.managedInstances" = {
        service_name = "Microsoft.Sql/managedInstances"
        service_actions = [
          "Microsoft.Network/virtualNetworks/subnets/join/action",
          "Microsoft.Network/virtualNetworks/subnets/prepareNetworkPolicies/action",
          "Microsoft.Network/virtualNetworks/subnets/unprepareNetworkPolicies/action",
        ]
      }
    }
  }
}
