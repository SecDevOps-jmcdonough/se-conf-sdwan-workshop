locals {

  route_tables = {
    "hub1_fgt_pub_rt"  = { name = "hub1_fgt_pub_rt", disable_bgp_route_propagation = "false" }
    "hub1_fgt_priv_rt" = { name = "hub1_fgt_priv_rt", disable_bgp_route_propagation = "true" }
    "hub1_fgt_ha_rt"   = { name = "hub1_fgt_ha_rt", disable_bgp_route_propagation = "true" }
    "hub1_fgt_mgmt_rt" = { name = "hub1_fgt_mgmt_rt", disable_bgp_route_propagation = "false" }


    "branch1_rt" = { name = "branch1_rt", vnet = "branch1", disable_bgp_route_propagation = "false" }
    "branch2_rt" = { name = "branch2_rt", vnet = "branch2", disable_bgp_route_propagation = "false" }
    "branch3_rt" = { name = "branch3_rt", vnet = "branch3", disable_bgp_route_propagation = "false" }
  }
}

module "module_azurerm_route_table" {
  for_each = local.route_tables

  source = "../azure/rm/azurerm_route_table"

  resource_group_name = module.module_azurerm_resource_group.resource_group.name
  location            = module.module_azurerm_resource_group.resource_group.location

  name                          = each.value.name
  disable_bgp_route_propagation = each.value.disable_bgp_route_propagation

  tags = {
    Project = local.project
  }
}

output "route_tables" {
  value = module.module_azurerm_route_table[*]
}
