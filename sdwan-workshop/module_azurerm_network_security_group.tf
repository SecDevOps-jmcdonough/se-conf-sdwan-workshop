locals {
  network_security_groups = {
    # Hub
    "nsg_pub"  = { name = "nsg_pub", vnet_name = "vnet_hub1" }
    "nsg_priv" = { name = "nsg_priv", vnet_name = "vnet_hub1" }

    # Branches
    "nsg_br1" = { name = "nsg_br1", vnet_name = "vnet_branch1" }
    "nsg_br2" = { name = "nsg_br2", vnet_name = "vnet_branch2" }
    "nsg_br3" = { name = "nsg_br3", vnet_name = "vnet_branch3" }
  }
}

module "module_azurerm_network_security_group" {
  for_each = local.network_security_groups

  source = "../azure/rm/azurerm_network_security_group"

  resource_group_name = module.module_azurerm_resource_group.resource_group.name
  location            = module.module_azurerm_virtual_network[each.value.vnet_name].virtual_network.location
  name                = each.value.name
}

output "network_security_groups" {
  value = module.module_azurerm_network_security_group[*]
}
