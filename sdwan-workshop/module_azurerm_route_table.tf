locals {

  route_tables = {
    "rt_hub1_fgt_public"  = { resource_group_name = module.module_azurerm_resource_group.resource_group.name, name = "rt_hub1_fgt_public", vnet_name = module.module_azurerm_virtual_network["vnet_hub1"].virtual_network.location, disable_bgp_route_propagation = "false" }
    "rt_hub1_fgt_private" = { resource_group_name = module.module_azurerm_resource_group.resource_group.name, name = "rt_hub1_fgt_private", vnet_name = module.module_azurerm_virtual_network["vnet_hub1"].virtual_network.location, disable_bgp_route_propagation = "true" }
    "rt_hub1_fgt_ha"      = { resource_group_name = module.module_azurerm_resource_group.resource_group.name, name = "rt_hub1_fgt_ha", vnet_name = module.module_azurerm_virtual_network["vnet_hub1"].virtual_network.location, disable_bgp_route_propagation = "true" }
    "rt_hub1_fgt_mgmt"    = { resource_group_name = module.module_azurerm_resource_group.resource_group.name, name = "rt_hub1_fgt_mgmt", vnet_name = module.module_azurerm_virtual_network["vnet_hub1"].virtual_network.location, disable_bgp_route_propagation = "false" }


    "rt_br1_protected" = { resource_group_name = module.module_azurerm_resource_group.resource_group.name, name = "rt_br1_protected", vnet_name = module.module_azurerm_virtual_network["vnet_branch1"].virtual_network.location, disable_bgp_route_propagation = "false" }
    "rt_br2_protected" = { resource_group_name = module.module_azurerm_resource_group.resource_group.name, name = "rt_br2_protected", vnet_name = module.module_azurerm_virtual_network["vnet_branch2"].virtual_network.location, disable_bgp_route_propagation = "false" }
    "rt_br3_protected" = { resource_group_name = module.module_azurerm_resource_group.resource_group.name, name = "rt_br3_protected", vnet_name = module.module_azurerm_virtual_network["vnet_branch3"].virtual_network.location, disable_bgp_route_propagation = "false" }
  }
}

module "module_azurerm_route_table" {
  for_each = local.route_tables

  source = "../azure/rm/azurerm_route_table"

  resource_group_name = each.value.resource_group_name
  location            = each.value.vnet_name

  name                          = each.value.name
  disable_bgp_route_propagation = each.value.disable_bgp_route_propagation

  tags = {
    Project = local.project
  }
}

output "route_tables" {
  value = module.module_azurerm_route_table[*]
}
