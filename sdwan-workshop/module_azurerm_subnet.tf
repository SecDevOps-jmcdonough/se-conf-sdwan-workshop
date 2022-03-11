locals {

  subnets = {
    # Hub 1
    "hub1_fgt_public"   = { name = "hub1_fgt_public", address_prefixes = [cidrsubnet(module.module_azurerm_virtual_network["vnet_hub1"].virtual_network.address_space[0], 8, 0)], vnet_name = "vnet_hub1" }
    "hub1_fgt_private"  = { name = "hub1_fgt_private", address_prefixes = [cidrsubnet(module.module_azurerm_virtual_network["vnet_hub1"].virtual_network.address_space[0], 8, 1)], vnet_name = "vnet_hub1" }
    "hub1_fgt_ha"       = { name = "hub1_fgt_ha", address_prefixes = [cidrsubnet(module.module_azurerm_virtual_network["vnet_hub1"].virtual_network.address_space[0], 8, 3)], vnet_name = "vnet_hub1" }
    "hub1_fgt_mgmt"     = { name = "hub1_fgt_mgmt", address_prefixes = [cidrsubnet(module.module_azurerm_virtual_network["vnet_hub1"].virtual_network.address_space[0], 8, 4)], vnet_name = "vnet_hub1" }
    "RouteServerSubnet" = { name = "RouteServerSubnet", address_prefixes = [cidrsubnet(module.module_azurerm_virtual_network["vnet_hub1"].virtual_network.address_space[0], 8, 2)], vnet_name = "vnet_hub1" }

    # Branch 1
    "br1_fgt_pub1"  = { name = "br1_fgt_pub1", address_prefixes = [cidrsubnet(module.module_azurerm_virtual_network["vnet_branch1"].virtual_network.address_space[0], 8, 1)], vnet_name = "vnet_branch1" }
    "br1_fgt_pub2"  = { name = "br1_fgt_pub2", address_prefixes = [cidrsubnet(module.module_azurerm_virtual_network["vnet_branch1"].virtual_network.address_space[0], 8, 11)], vnet_name = "vnet_branch1" }
    "br1_fgt_priv"  = { name = "br1_fgt_priv", address_prefixes = [cidrsubnet(module.module_azurerm_virtual_network["vnet_branch1"].virtual_network.address_space[0], 8, 2)], vnet_name = "vnet_branch1" }
    "br1_fgt_ha"    = { name = "br1_fgt_ha", address_prefixes = [cidrsubnet(module.module_azurerm_virtual_network["vnet_branch1"].virtual_network.address_space[0], 8, 3)], vnet_name = "vnet_branch1" }
    "br1_fgt_mgmt"  = { name = "br1_fgt_mgmt", address_prefixes = [cidrsubnet(module.module_azurerm_virtual_network["vnet_branch1"].virtual_network.address_space[0], 8, 4)], vnet_name = "vnet_branch1" }
    "br1_protected" = { name = "br1_protected", address_prefixes = [cidrsubnet(module.module_azurerm_virtual_network["vnet_branch1"].virtual_network.address_space[0], 8, 5)], vnet_name = "vnet_branch1" }

    # Branch 2
    "br2_fgt_pub1"  = { name = "br2_fgt_pub1", address_prefixes = [cidrsubnet(module.module_azurerm_virtual_network["vnet_branch2"].virtual_network.address_space[0], 8, 1)], vnet_name = "vnet_branch2" }
    "br2_fgt_pub2"  = { name = "br2_fgt_pub2", address_prefixes = [cidrsubnet(module.module_azurerm_virtual_network["vnet_branch2"].virtual_network.address_space[0], 8, 11)], vnet_name = "vnet_branch2" }
    "br2_fgt_priv"  = { name = "br2_fgt_priv", address_prefixes = [cidrsubnet(module.module_azurerm_virtual_network["vnet_branch2"].virtual_network.address_space[0], 8, 2)], vnet_name = "vnet_branch2" }
    "br2_fgt_ha"    = { name = "br2_fgt_ha", address_prefixes = [cidrsubnet(module.module_azurerm_virtual_network["vnet_branch2"].virtual_network.address_space[0], 8, 3)], vnet_name = "vnet_branch2" }
    "br2_fgt_mgmt"  = { name = "br2_fgt_mgmt", address_prefixes = [cidrsubnet(module.module_azurerm_virtual_network["vnet_branch2"].virtual_network.address_space[0], 8, 4)], vnet_name = "vnet_branch2" }
    "br2_protected" = { name = "br2_protected", address_prefixes = [cidrsubnet(module.module_azurerm_virtual_network["vnet_branch2"].virtual_network.address_space[0], 8, 5)], vnet_name = "vnet_branch2" }

    # Branch 3
    "br3_fgt_pub1"  = { name = "br3_fgt_pub1", address_prefixes = [cidrsubnet(module.module_azurerm_virtual_network["vnet_branch3"].virtual_network.address_space[0], 8, 1)], vnet_name = "vnet_branch3" }
    "br3_fgt_pub2"  = { name = "br3_fgt_pub2", address_prefixes = [cidrsubnet(module.module_azurerm_virtual_network["vnet_branch3"].virtual_network.address_space[0], 8, 11)], vnet_name = "vnet_branch3" }
    "br3_fgt_priv"  = { name = "br3_fgt_priv", address_prefixes = [cidrsubnet(module.module_azurerm_virtual_network["vnet_branch3"].virtual_network.address_space[0], 8, 2)], vnet_name = "vnet_branch3" }
    "br3_protected" = { name = "br3_protected", address_prefixes = [cidrsubnet(module.module_azurerm_virtual_network["vnet_branch3"].virtual_network.address_space[0], 8, 5)], vnet_name = "vnet_branch3" }

    # Spokes
    "spoke11_subnet1" = { name = "spoke11_subnet1", address_prefixes = [cidrsubnet(module.module_azurerm_virtual_network["vnet_spoke11"].virtual_network.address_space[0], 8, 0)], vnet_name = "vnet_spoke11" }
    "spoke12_subnet1" = { name = "spoke12_subnet1", address_prefixes = [cidrsubnet(module.module_azurerm_virtual_network["vnet_spoke12"].virtual_network.address_space[0], 8, 0)], vnet_name = "vnet_spoke12" }
  }
}

module "module_azurerm_subnet" {
  for_each = local.subnets

  source = "../azure/rm/azurerm_subnet"

  resource_group_name = module.module_azurerm_resource_group.resource_group.name
  name                = each.value.name
  vnet_name           = module.module_azurerm_virtual_network[each.value.vnet_name].virtual_network.name
  address_prefixes    = each.value.address_prefixes

}

output "subnets" {
  value = module.module_azurerm_subnet[*]
}
