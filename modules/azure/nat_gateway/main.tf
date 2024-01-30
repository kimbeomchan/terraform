locals {

}

#------------------------------
# Public IP (NAT)
#------------------------------
resource "azurerm_public_ip" "pip" {
  for_each            = var.nat-gateway
  name                = each.key
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = lookup(each.value, "allocation_method", "Static")
  sku                 = lookup(each.value, "sku", "Standard")
}

#------------------------------
# Public IP Prefix (NAT)
#------------------------------
# resource "azurerm_public_ip_prefix" "pip-prefix" {
#   #for_each            = var.nat-gateway["public_ip_prefix_length"] == null ? [] : [1]
#   for_each            = { for name, nat in var.nat-gateway : name => nat if nat.public_ip_prefix_length != "" }
#   name                = "pip-prefix-${each.key}"
#   location            = var.location
#   resource_group_name = var.resource_group_name
#   prefix_length       = lookup(each.value, "public_ip_prefix_length", null)
# }

#------------------------------
# Azure NAT Gateway 
#------------------------------
resource "azurerm_nat_gateway" "nat" {
  for_each                = var.nat-gateway
  name                    = each.key
  location                = var.location
  resource_group_name     = var.resource_group_name
  sku_name                = lookup(each.value, "sku_name", "Standard")
  idle_timeout_in_minutes = lookup(each.value, "idle_timeout_in_minutes", 4)
}

#------------------------------
# NAT & Public IP Association
#------------------------------
resource "azurerm_nat_gateway_public_ip_association" "association" {
  for_each             = var.nat-gateway
  nat_gateway_id       = azurerm_nat_gateway.nat[each.key].id
  public_ip_address_id = azurerm_public_ip.pip[each.key].id
}

#--------------------------------------------
# NAT & Public IP Prefix Association
#--------------------------------------------
# resource "azurerm_nat_gateway_public_ip_prefix_association" "association" {
#   for_each            = var.nat-gateway
#   nat_gateway_id      = azurerm_nat_gateway.nat[each.key].id
#   public_ip_prefix_id = azurerm_public_ip_prefix.pip-prefix[each.key].id
# }

#--------------------------------------------
# NAT & Subnets Association
#--------------------------------------------
resource "azurerm_subnet_nat_gateway_association" "association" {
  for_each       = var.nat-gateway
  subnet_id      = each.value.subnet_id
  nat_gateway_id = azurerm_nat_gateway.nat[each.key].id
}
