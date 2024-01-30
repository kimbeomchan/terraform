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
# Azure Network Security Group (nsg)
#---------------------------------------------------------------
resource "azurerm_network_security_group" "nsg" {
  name                = var.name
  resource_group_name = var.resource_group_name
  location            = var.location
  tags                = var.tags

  dynamic "security_rule" {
    for_each = try(var.security_rules, [])
    content {
      name                       = try(security_rule.value.name, null)
      description                = try(security_rule.value.description, null)
      priority                   = try(security_rule.value.priority, null)
      direction                  = try(security_rule.value.direction, null)
      access                     = try(security_rule.value.access, null)
      protocol                   = try(security_rule.value.protocol, null)
      source_port_range          = try(security_rule.value.source_port_range, null)
      source_address_prefix      = try(security_rule.value.source_address_prefix, null)
      destination_port_range     = try(security_rule.value.destination_port_range, null)
      destination_address_prefix = try(security_rule.value.destination_address_prefix, null)
    }
  }

  lifecycle {
    ignore_changes = [
      tags
    ]
  }
}
