locals {
  virtual_networks = {
    # Hub
    "hub1" = { name = "hub1", address_space = ["10.10.0.0/16"], location = "eastus" }

    # Brances
    "branch1" = { name = "branch1", address_space = ["172.16.0.0/16"], location = "eastus" }
    "branch2" = { name = "branch2", address_space = ["172.17.0.0/16"], location = "eastus" }
    "branch3" = { name = "branch3", address_space = ["172.18.0.0/16"], location = "southcentralus" }

    # Spokes
    "spoke11" = { name = "spoke11", address_space = ["10.11.0.0/16"], location = "eastus" }
    "spoke12" = { name = "spoke12", address_space = ["10.12.0.0/16"], location = "eastus" }
  }
}
module "module_azurerm_virtual_network" {
  for_each = local.virtual_networks

  source = "../azure/rm/azurerm_virtual_network"

  resource_group_name = module.module_azurerm_resource_group.resource_group.name
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
