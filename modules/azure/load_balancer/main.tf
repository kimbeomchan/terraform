data "azurerm_resource_group" "rg_nic" {
  name = "smp-hub-fw-rg"
}

data "azurerm_network_interface" "nic" {
  for_each            = var.nic_backend_asso
  name                = each.key
  resource_group_name = data.azurerm_resource_group.rg_nic.name
}

output "network_interface_id" {
  value = { for nic in data.azurerm_network_interface.nic : nic.name => nic.id }
}

#------------------------------
# Azure Public IP (LB)
#------------------------------
resource "azurerm_public_ip" "pip" {
  for_each            = toset(var.allocate_public_ip ? ["enabled"] : [])
  name                = var.pip_name
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = var.pip_allocation_method
  sku                 = var.pip_sku
}

#------------------------------
# Azure Load Balancer
#------------------------------
resource "azurerm_lb" "lb" {
  name                = var.lb_name
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = "Standard"

  dynamic "frontend_ip_configuration" {
    for_each = azurerm_public_ip.pip
    content {
      name                 = var.fip_name
      public_ip_address_id = frontend_ip_configuration.value.id
    }
  }

  dynamic "frontend_ip_configuration" {
    for_each = var.allocate_public_ip ? [] : [1]
    content {
      name                          = var.fip_name
      private_ip_address            = var.private_ip_address
      private_ip_address_allocation = var.private_ip_address_allocation
      subnet_id                     = var.subnet_id
    }
  }
}

#------------------------------
# Backend address pool (LB)
#------------------------------
resource "azurerm_lb_backend_address_pool" "backendpool" {
  for_each        = var.lb_back_pools
  name            = each.key
  loadbalancer_id = azurerm_lb.lb.id
}

#-----------------------------------------
# NIC & Backend address pool Association
#-----------------------------------------
resource "azurerm_network_interface_backend_address_pool_association" "nic_back_asso" {
  for_each                = var.nic_backend_asso
  backend_address_pool_id = azurerm_lb_backend_address_pool.backendpool[each.value.backendpool_name].id
  network_interface_id    = data.azurerm_network_interface.nic[each.key].id
  ip_configuration_name   = "ip-${each.key}"
}

#------------------------------
# Probe (LB)
#------------------------------
resource "azurerm_lb_probe" "probe" {
  depends_on          = [azurerm_lb.lb]
  for_each            = var.lb_probes
  loadbalancer_id     = azurerm_lb.lb.id
  name                = each.key
  port                = each.value.lb_probe_port
  protocol            = each.value.lb_probe_protocol
  interval_in_seconds = each.value.interval_in_seconds
}

#------------------------------
# Rule (LB)
#------------------------------
resource "azurerm_lb_rule" "lb_rule" {
  depends_on                     = [azurerm_lb.lb]
  for_each                       = var.lb_rules
  name                           = each.key
  loadbalancer_id                = azurerm_lb.lb.id
  backend_address_pool_ids       = [azurerm_lb_backend_address_pool.backendpool[each.value.lb_back_pool_name].id]
  probe_id                       = azurerm_lb_probe.probe[each.value.lb_probe_name].id
  protocol                       = each.value.lb_rule_protocol
  frontend_port                  = each.value.lb_rule_frontend_port
  backend_port                   = each.value.lb_rule_backend_port
  frontend_ip_configuration_name = var.fip_name
  enable_floating_ip             = each.value.enable_floating_ip
  disable_outbound_snat          = each.value.disable_outbound_snat
}
