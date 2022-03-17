locals {

  virtual_network_peerings = {
    # Hub 1
    "hub1_to_spoke11" = { name = "hub1_to_spoke11", virtual_network_name = "vnet_hub1", remote_virtual_network_id = "vnet_spoke11", use_remote_gateways = null, allow_gateway_transit = true }
    "hub1_to_spoke12" = { name = "hub1_to_spoke12", virtual_network_name = "vnet_hub1", remote_virtual_network_id = "vnet_spoke12", use_remote_gateways = null, allow_gateway_transit = true }


    # Spokes
    "spoke11_to_hub1" = { name = "spoke11_to_hub1", virtual_network_name = "vnet_spoke11", remote_virtual_network_id = "vnet_hub1", use_remote_gateways = true, allow_gateway_transit = null }
    "spoke12_to_hub1" = { name = "spoke12_to_hub1", virtual_network_name = "vnet_spoke12", remote_virtual_network_id = "vnet_hub1", use_remote_gateways = true, allow_gateway_transit = null }
  }
}

module "module_azurerm_virtual_network_peering" {
  for_each = local.virtual_network_peerings

  source = "../azure/rm/azurerm_virtual_network_peering"

  resource_group_name = module.module_azurerm_resource_group.resource_group.name

  name                      = each.value.name
  virtual_network_name      = module.module_azurerm_virtual_network[each.value.virtual_network_name].virtual_network.name
  remote_virtual_network_id = module.module_azurerm_virtual_network[each.value.remote_virtual_network_id].virtual_network.id

  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
  use_remote_gateways          = each.value.use_remote_gateways
  allow_gateway_transit        = each.value.allow_gateway_transit

  depends_on = [
    module.module_azurerm_resource_group_template_deployment["sdwan_workshop_ars"].resource_group_template_deployment
  ]
}

output "virtual_network_peerings" {
  value = module.module_azurerm_virtual_network_peering[*]
}