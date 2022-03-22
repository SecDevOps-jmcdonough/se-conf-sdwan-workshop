locals {
  virtual_networks = {
    # Hub
    "vnet_hub1" = { resource_group_name = module.module_azurerm_resource_group.resource_group.name, location = "eastus", name = "vnet_hub1", address_space = ["10.10.0.0/16"] }

    # Branches
    "vnet_branch1" = { resource_group_name = module.module_azurerm_resource_group.resource_group.name, location = "eastus", name = "vnet_branch1", address_space = ["172.16.0.0/16"] }
    "vnet_branch2" = { resource_group_name = module.module_azurerm_resource_group.resource_group.name, location = "eastus", name = "vnet_branch2", address_space = ["172.17.0.0/16"] }
    "vnet_branch3" = { resource_group_name = module.module_azurerm_resource_group.resource_group.name, location = "southcentralus", name = "vnet_branch3", address_space = ["172.18.0.0/16"] }

    # Spokes
    "vnet_spoke11" = { resource_group_name = module.module_azurerm_resource_group.resource_group.name, location = "eastus", name = "vnet_spoke11", address_space = ["10.11.0.0/16"] }
    "vnet_spoke12" = { resource_group_name = module.module_azurerm_resource_group.resource_group.name, location = "eastus", name = "vnet_spoke12", address_space = ["10.12.0.0/16"] }
  }
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
