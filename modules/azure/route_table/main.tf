terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.29.1"
    }
  }
  required_version = "1.3.4"
}

#---------------------------------------------------------------
# Azure User Defined Routing (udr)
#---------------------------------------------------------------

resource "azurerm_route_table" "rt" {
  name                = var.name
  resource_group_name = var.resource_group_name
  location            = var.location
  tags                = var.tags

  dynamic "route" {
    for_each = try(var.rt_rules, [])
    content {
    name                   = try(route.value.name, null)
    address_prefix         = try(route.value.address_prefix, null)
    next_hop_type          = try(route.value.next_hop_type, null)
    next_hop_in_ip_address = try(route.value.next_hop_in_ip_address, null)
    }
  }

  lifecycle {
    ignore_changes = [
      tags
    ]
  }
}