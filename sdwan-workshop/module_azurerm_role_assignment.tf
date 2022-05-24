locals {
  role_assignments = merge(local.hub_role_assignments, local.branch_role_assignments)
}

data "azurerm_resource_group" "resource_group" {
  name = local.resource_group_name
}

module "module_azurerm_role_assignment" {
  for_each = local.role_assignments

  source = "../azure/rm/azurerm_role_assignment"

  scope                = data.azurerm_resource_group.resource_group.id
  role_definition_name = each.value.role_definition_name
  principal_id         = module.module_azurerm_virtual_machine[each.key].virtual_machine.identity[0].principal_id
}

output "role_assignments" {
  value = var.enable_module_output ? module.module_azurerm_role_assignment[*] : null
}
