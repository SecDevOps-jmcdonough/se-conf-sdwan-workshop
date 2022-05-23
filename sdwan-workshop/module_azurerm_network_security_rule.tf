locals {
  network_security_rules = merge(local.hub_network_security_rules, local.branch_network_security_rules)
}

module "module_azurerm_network_security_rule" {
  for_each = local.network_security_rules

  source = "../azure/rm/azurerm_network_security_rule"

  resource_group_name = each.value.resource_group_name

  name                        = each.value.name
  network_security_group_name = each.value.network_security_group_name

  priority  = each.value.priority
  direction = each.value.direction
  access    = each.value.access
  protocol  = each.value.protocol
}

output "network_security_rules" {
  value = var.enable_module_output ? module.module_azurerm_network_security_rule[*] : null
}
