locals {
  lb_nat_rules = merge(local.hub_lb_nat_rules, local.branch_lb_nat_rules)
}

module "module_azurerm_lb_nat_rule" {
  for_each = local.lb_nat_rules

  source = "../azure/rm/azurerm_lb_nat_rule"

  resource_group_name = module.module_azurerm_resource_group.resource_group.name

  name                           = each.value.name
  loadbalancer_id                = each.value.loadbalancer_id
  protocol                       = each.value.protocol
  frontend_port                  = each.value.frontend_port
  backend_port                   = each.value.backend_port
  frontend_ip_configuration_name = each.value.frontend_ip_configuration_name

}

output "lb_nat_rules" {
  value = var.enable_module_output ? module.module_azurerm_lb_nat_rule[*] : null
}