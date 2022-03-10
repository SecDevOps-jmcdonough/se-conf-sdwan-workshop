locals {
  network_security_rules = {
    # Hub
    "hub1_pub_all_inbound"   = { name = "hub1_pub_all_inbound", network_security_group_name = "nsg_pub", priority = "100", direction = "Inbound", access = "Allow", protocol = "*"}
    "hub1_pub_all_outbound"  = { name = "hub1_pub_all_outbound", network_security_group_name = "nsg_pub", priority = "100", direction = "Outbound", access = "Allow", protocol = "*"}
    "hub1_priv_all_inbound"  = { name = "hub1_priv_all_inbound", network_security_group_name = "nsg_priv", priority = "100", direction = "Inbound", access = "Allow", protocol = "*"}
    "hub1_priv_all_outbound" = { name = "hub1_priv_all_outbound", network_security_group_name = "nsg_priv", priority = "100", direction = "Outbound", access = "Allow", protocol = "*"}

    # Branches
    "br1_all_inbound"  = { name = "br1_all_inbound", network_security_group_name = "nsg_br1", priority = "100", direction = "Inbound", access = "Allow", protocol = "*" }
    "br1_all_outbound" = { name = "br1_all_outbound", network_security_group_name = "nsg_br1", priority = "100", direction = "Outbound", access = "Allow", protocol = "*" }
    "br2_all_inbound"  = { name = "br2_all_inbound", network_security_group_name = "nsg_br2", priority = "100", direction = "Inbound", access = "Allow", protocol = "*" }
    "br2_all_outbound" = { name = "br2_all_outbound", network_security_group_name = "nsg_br2", priority = "100", direction = "Outbound", access = "Allow", protocol = "*" }
    "br3_all_inbound"  = { name = "br3_all_inbound", network_security_group_name = "nsg_br3", priority = "100", direction = "Inbound", access = "Allow", protocol = "*" }
    "br3_all_outbound" = { name = "br3_all_outbound", network_security_group_name = "nsg_br3", priority = "100", direction = "Outbound", access = "Allow", protocol = "*" }
  }
}

module "module_azurerm_network_security_rule" {
  for_each = local.network_security_rules

  source = "../azure/rm/azurerm_network_security_rule"

  resource_group_name = module.module_azurerm_resource_group.resource_group.name

  name                        = each.value.name
  network_security_group_name = module.module_azurerm_network_security_group[each.value.network_security_group_name].network_security_group.name

  priority  = each.value.priority
  direction = each.value.direction
  access    = each.value.access
  protocol  = each.value.protocol
}

output "network_security_rules" {
  value = module.module_azurerm_network_security_rule[*]
}
