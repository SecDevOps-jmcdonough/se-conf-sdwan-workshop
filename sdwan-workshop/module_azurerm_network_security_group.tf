locals {
  network_security_groups = {
    # Hub
    "nsg_pub"  = { resource_group_name = module.module_azurerm_resource_group.resource_group.name, name = "nsg_pub", vnet_name = module.module_azurerm_virtual_network["vnet_hub1"].virtual_network.location }
    "nsg_priv" = { resource_group_name = module.module_azurerm_resource_group.resource_group.name, name = "nsg_priv", vnet_name = module.module_azurerm_virtual_network["vnet_hub1"].virtual_network.location }

    # Branches
    "nsg_br1" = { resource_group_name = module.module_azurerm_resource_group.resource_group.name, name = "nsg_br1", vnet_name = module.module_azurerm_virtual_network["vnet_branch1"].virtual_network.location }
    "nsg_br2" = { resource_group_name = module.module_azurerm_resource_group.resource_group.name, name = "nsg_br2", vnet_name = module.module_azurerm_virtual_network["vnet_branch2"].virtual_network.location }
    "nsg_br3" = { resource_group_name = module.module_azurerm_resource_group.resource_group.name, name = "nsg_br3", vnet_name = module.module_azurerm_virtual_network["vnet_branch3"].virtual_network.location }
  }
}

module "module_azurerm_network_security_group" {
  for_each = local.network_security_groups

  source = "../azure/rm/azurerm_network_security_group"

  resource_group_name = each.value.resource_group_name
  location            = each.value.vnet_name
  name                = each.value.name
}

output "network_security_groups" {
  value = module.module_azurerm_network_security_group[*]
}
