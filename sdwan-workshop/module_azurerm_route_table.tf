locals {
  route_tables = merge(local.hub_route_tables, local.branch_route_tables)
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
  value = var.enable_module_output ? module.module_azurerm_route_table[*] : null
}
