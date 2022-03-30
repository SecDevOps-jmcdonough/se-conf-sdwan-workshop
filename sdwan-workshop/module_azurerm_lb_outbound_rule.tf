locals {
  lb_outbound_rules = merge(local.hub_lb_outbound_rules, local.branch_lb_outbound_rules)
}

module "module_azurerm_lb_outbound_rule" {
  for_each = local.lb_outbound_rules

  source = "../azure/rm/azurerm_lb_outbound_rule"

  resource_group_name = each.value.resource_group_name

  name                       = each.value.name
  loadbalancer_id            = each.value.loadbalancer_id
  backend_address_pool_id    = each.value.backend_address_pool_id
  protocol                   = each.value.protocol
  frontend_ip_configurations = each.value.frontend_ip_configurations

}

output "lb_outbound_rules" {
  value = module.module_azurerm_lb_outbound_rule[*]
}
