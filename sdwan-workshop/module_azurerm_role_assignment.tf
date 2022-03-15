locals {
  role_assignments = {
    "vm_fgt_1" = { role_definition_name = "Reader" }
    "vm_fgt_2" = { role_definition_name = "Reader" }
  }
}

module "module_azurerm_role_assignment" {
  for_each = local.role_assignments

  source = "../azure/rm/azurerm_role_assignment"

  scope                = module.module_azurerm_resource_group.resource_group.id
  role_definition_name = each.value.role_definition_name
  principal_id         = module.module_azurerm_virtual_machine[each.key].virtual_machine.identity[0].principal_id
}

output "role_assignments" {
  value = module.module_azurerm_role_assignment[*]
}
