locals {
  lb_rules = merge(local.hub_lb_rules, local.branch_lb_rules)
}

module "module_azurerm_lb_rule" {
  for_each = local.lb_rules

  source = "../azure/rm/azurerm_lb_rule"

  resource_group_name = each.value.resource_group_name

  name                           = each.value.name
  loadbalancer_id                = each.value.loadbalancer_id
  frontend_ip_configuration_name = each.value.frontend_ip_configuration_name
  protocol                       = each.value.protocol
  frontend_port                  = each.value.frontend_port
  backend_port                   = each.value.backend_port
  backend_address_pool_ids       = each.value.backend_address_pool_ids
  probe_id                       = each.value.probe_id
  disable_outbound_snat          = each.value.disable_outbound_snat
}

output "lb_rules" {
  value = var.enable_module_output ? module.module_azurerm_lb_rule[*] : null
}
