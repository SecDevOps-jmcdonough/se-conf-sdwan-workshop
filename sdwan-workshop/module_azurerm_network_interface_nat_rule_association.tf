locals {
  network_interface_nat_rule_associations = merge(local.hub_network_interface_nat_rule_associations, local.branch_network_interface_nat_rule_associations)
}

module "module_azurerm_network_interface_nat_rule_association" {
  for_each = local.network_interface_nat_rule_associations

  source = "../azure/rm/azurerm_network_interface_nat_rule_association"

  network_interface_id  = each.value.network_interface_id
  ip_configuration_name = each.value.ip_configuration_name
  nat_rule_id           = each.value.nat_rule_id
}

output "network_interface_nat_rule_associations" {
  value = module.module_azurerm_network_interface_nat_rule_association[*]
}
