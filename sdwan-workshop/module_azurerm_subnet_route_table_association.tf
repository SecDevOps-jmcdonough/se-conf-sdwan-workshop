locals {
  subnet_route_table_associations = {
    "hub1_fgt_public"  = { subnet_id = "hub1_fgt_public", route_table_id = "rt_hub1_fgt_public" }
    "hub1_fgt_private" = { subnet_id = "hub1_fgt_private", route_table_id = "rt_hub1_fgt_private" }
    "hub1_fgt_ha"      = { subnet_id = "hub1_fgt_ha", route_table_id = "rt_hub1_fgt_ha" }
    "hub1_fgt_mgmt"    = { subnet_id = "hub1_fgt_mgmt", route_table_id = "rt_hub1_fgt_mgmt" }

    "br1_protected" = { subnet_id = "br1_protected", route_table_id = "rt_br1_protected" }
    "br2_protected" = { subnet_id = "br2_protected", route_table_id = "rt_br2_protected" }
    "br3_protected" = { subnet_id = "br3_protected", route_table_id = "rt_br3_protected" }
  }
}

module "module_azurerm_subnet_route_table_association" {
  for_each = local.subnet_route_table_associations

  source = "../azure/rm/azurerm_subnet_route_table_association"

  subnet_id      = module.module_azurerm_subnet[each.value.subnet_id].subnet.id
  route_table_id = module.module_azurerm_route_table[each.value.route_table_id].route_table.id
}

output "subnet_route_table_associations" {
  value = module.module_azurerm_subnet_route_table_association[*]
}
