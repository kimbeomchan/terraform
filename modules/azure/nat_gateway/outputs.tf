output "nat_gateway" {
  value = { for nat in azurerm_nat_gateway.nat : nat.name => nat.id }
}

# output "prefix_id" {
#   value = { for prefix in azurerm_public_ip_prefix.pip-prefix : prefix.name => prefix }
# }
