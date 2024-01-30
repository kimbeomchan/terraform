output "untrusted_subnet_id" {
  value = data.azurerm_subnet.untrusted.id
}

output "trusted_subnet_id" {
  value = data.azurerm_subnet.trusted.id
}

output "network_interface_id" {
  value = { for nic in data.azurerm_network_interface.nic : nic.name => nic.id }
}
