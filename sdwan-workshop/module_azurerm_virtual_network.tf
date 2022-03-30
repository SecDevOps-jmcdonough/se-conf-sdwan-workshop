locals {
  virtual_networks = merge(local.hub_vnets, local.branch_vnets, local.spoke_vnets)
}

module "module_azurerm_virtual_network" {
  for_each = local.virtual_networks

  source = "../azure/rm/azurerm_virtual_network"

  resource_group_name = each.value.resource_group_name
  location            = each.value.location
  name                = each.value.name
  address_space       = each.value.address_space

  tags = {
    Project = local.project
    Role    = local.tag
  }
}

output "virtual_networks" {
  value = module.module_azurerm_virtual_network[*]
}
