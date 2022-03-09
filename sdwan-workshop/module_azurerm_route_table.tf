locals {

  route_tables = {
    "rt_hub1_fgt_public"  = { name = "rt_hub1_fgt_public", vnet_name = "vnet_hub1", disable_bgp_route_propagation = "false" }
    "rt_hub1_fgt_private" = { name = "rt_hub1_fgt_private", vnet_name = "vnet_hub1", disable_bgp_route_propagation = "true" }
    "rt_hub1_fgt_ha"      = { name = "rt_hub1_fgt_ha", vnet_name = "vnet_hub1", disable_bgp_route_propagation = "true" }
    "rt_hub1_fgt_mgmt"    = { name = "rt_hub1_fgt_mgmt", vnet_name = "vnet_hub1", disable_bgp_route_propagation = "false" }


    "rt_br1_protected" = { name = "rt_br1_protected", vnet_name = "vnet_branch1", disable_bgp_route_propagation = "false" }
    "rt_br2_protected" = { name = "rt_br2_protected", vnet_name = "vnet_branch2", disable_bgp_route_propagation = "false" }
    "rt_br3_protected" = { name = "rt_br3_protected", vnet_name = "vnet_branch3", disable_bgp_route_propagation = "false" }
  }
}

module "module_azurerm_route_table" {
  for_each = local.route_tables

  source = "../azure/rm/azurerm_route_table"

  resource_group_name = module.module_azurerm_resource_group.resource_group.name
  location            = module.module_azurerm_virtual_network[each.value.vnet_name].virtual_network.location

  name                          = each.value.name
  disable_bgp_route_propagation = each.value.disable_bgp_route_propagation

  tags = {
    Project = local.project
  }
}

output "route_tables" {
  value = module.module_azurerm_route_table[*]
}
