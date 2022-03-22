locals {
  subnet_route_table_associations = {
    "hub1_fgt_public"  = { subnet_id = module.module_azurerm_subnet["hub1_fgt_public"].subnet.id, route_table_id = module.module_azurerm_route_table["rt_hub1_fgt_public"].route_table.id }
    "hub1_fgt_private" = { subnet_id = module.module_azurerm_subnet["hub1_fgt_private"].subnet.id, route_table_id = module.module_azurerm_route_table["rt_hub1_fgt_private"].route_table.id }
    "hub1_fgt_ha"      = { subnet_id = module.module_azurerm_subnet["hub1_fgt_ha"].subnet.id, route_table_id = module.module_azurerm_route_table["rt_hub1_fgt_ha"].route_table.id }
    "hub1_fgt_mgmt"    = { subnet_id = module.module_azurerm_subnet["hub1_fgt_mgmt"].subnet.id, route_table_id = module.module_azurerm_route_table["rt_hub1_fgt_mgmt"].route_table.id }

    "br1_protected" = { subnet_id = module.module_azurerm_subnet["br1_protected"].subnet.id, route_table_id = module.module_azurerm_route_table["rt_br1_protected"].route_table.id }
    "br2_protected" = { subnet_id = module.module_azurerm_subnet["br2_protected"].subnet.id, route_table_id = module.module_azurerm_route_table["rt_br2_protected"].route_table.id }
    "br3_protected" = { subnet_id = module.module_azurerm_subnet["br3_protected"].subnet.id, route_table_id = module.module_azurerm_route_table["rt_br3_protected"].route_table.id }
  }
}

module "module_azurerm_subnet_route_table_association" {
  for_each = local.subnet_route_table_associations

  source = "../azure/rm/azurerm_subnet_route_table_association"

  subnet_id      = each.value.subnet_id
  route_table_id = each.value.route_table_id
}

output "subnet_route_table_associations" {
  value = module.module_azurerm_subnet_route_table_association[*]
}
