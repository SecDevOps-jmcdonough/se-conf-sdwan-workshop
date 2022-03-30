locals {
  network_interface_backend_address_pool_associations = merge(local.hub_network_interface_backend_address_pool_associations, local.branch_network_interface_backend_address_pool_associations)
}

module "module_azurerm_network_interface_backend_address_pool_association" {
  for_each = local.network_interface_backend_address_pool_associations

  source = "../azure/rm/azurerm_network_interface_backend_address_pool_association"

  network_interface_id    = each.value.network_interface_id
  ip_configuration_name   = each.value.ip_configuration_name
  backend_address_pool_id = each.value.backend_address_pool_id
}

output "network_interface_backend_address_pool_association" {
  value = module.module_azurerm_network_interface_backend_address_pool_association[*]
}
