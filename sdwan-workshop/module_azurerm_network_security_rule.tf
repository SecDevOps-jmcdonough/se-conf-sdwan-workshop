locals {
  network_security_rules = {
    # Hub
    "hub1_pub_all_inbound"   = { resource_group_name = module.module_azurerm_resource_group.resource_group.name, name = "hub1_pub_all_inbound", network_security_group_name = module.module_azurerm_network_security_group["nsg_pub"].network_security_group.name, priority = "100", direction = "Inbound", access = "Allow", protocol = "*" }
    "hub1_pub_all_outbound"  = { resource_group_name = module.module_azurerm_resource_group.resource_group.name, name = "hub1_pub_all_outbound", network_security_group_name = module.module_azurerm_network_security_group["nsg_pub"].network_security_group.name, priority = "100", direction = "Outbound", access = "Allow", protocol = "*" }
    "hub1_priv_all_inbound"  = { resource_group_name = module.module_azurerm_resource_group.resource_group.name, name = "hub1_priv_all_inbound", network_security_group_name = module.module_azurerm_network_security_group["nsg_priv"].network_security_group.name, priority = "100", direction = "Inbound", access = "Allow", protocol = "*" }
    "hub1_priv_all_outbound" = { resource_group_name = module.module_azurerm_resource_group.resource_group.name, name = "hub1_priv_all_outbound", network_security_group_name = module.module_azurerm_network_security_group["nsg_priv"].network_security_group.name, priority = "100", direction = "Outbound", access = "Allow", protocol = "*" }

    # Branches
    "br1_all_inbound"  = { resource_group_name = module.module_azurerm_resource_group.resource_group.name, name = "br1_all_inbound", network_security_group_name = module.module_azurerm_network_security_group["nsg_br1"].network_security_group.name, priority = "100", direction = "Inbound", access = "Allow", protocol = "*" }
    "br1_all_outbound" = { resource_group_name = module.module_azurerm_resource_group.resource_group.name, name = "br1_all_outbound", network_security_group_name = module.module_azurerm_network_security_group["nsg_br1"].network_security_group.name, priority = "100", direction = "Outbound", access = "Allow", protocol = "*" }
    "br2_all_inbound"  = { resource_group_name = module.module_azurerm_resource_group.resource_group.name, name = "br2_all_inbound", network_security_group_name = module.module_azurerm_network_security_group["nsg_br2"].network_security_group.name, priority = "100", direction = "Inbound", access = "Allow", protocol = "*" }
    "br2_all_outbound" = { resource_group_name = module.module_azurerm_resource_group.resource_group.name, name = "br2_all_outbound", network_security_group_name = module.module_azurerm_network_security_group["nsg_br2"].network_security_group.name, priority = "100", direction = "Outbound", access = "Allow", protocol = "*" }
    "br3_all_inbound"  = { resource_group_name = module.module_azurerm_resource_group.resource_group.name, name = "br3_all_inbound", network_security_group_name = module.module_azurerm_network_security_group["nsg_br3"].network_security_group.name, priority = "100", direction = "Inbound", access = "Allow", protocol = "*" }
    "br3_all_outbound" = { resource_group_name = module.module_azurerm_resource_group.resource_group.name, name = "br3_all_outbound", network_security_group_name = module.module_azurerm_network_security_group["nsg_br3"].network_security_group.name, priority = "100", direction = "Outbound", access = "Allow", protocol = "*" }
  }
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
  value = module.module_azurerm_network_security_rule[*]
}
