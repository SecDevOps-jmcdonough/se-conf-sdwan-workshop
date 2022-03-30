locals {
  network_interface_security_group_associations = merge(local.hub_network_interface_security_group_associations, local.branch_network_interface_security_group_associations)
}

module "module_azurerm_network_interface_security_group_association" {
  for_each = local.network_interface_security_group_associations

  source = "../azure/rm/azurerm_network_interface_security_group_association"

  network_interface_id      = each.value.network_interface_id
  network_security_group_id = each.value.network_security_group_id
}

output "network_interface_security_group_associations" {
  value =  var.enable_module_output ? module.module_azurerm_network_interface_security_group_association[*] : null
}
