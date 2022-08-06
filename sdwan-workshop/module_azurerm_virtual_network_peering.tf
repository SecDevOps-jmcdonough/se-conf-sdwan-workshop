module "module_azurerm_virtual_network_peering" {
  for_each = local.virtual_network_peerings

  source = "../azure/rm/azurerm_virtual_network_peering"

  resource_group_name = each.value.resource_group_name

  name                      = each.value.name
  virtual_network_name      = each.value.virtual_network_name
  remote_virtual_network_id = each.value.remote_virtual_network_id

  allow_virtual_network_access = each.value.allow_virtual_network_access
  allow_forwarded_traffic      = each.value.allow_forwarded_traffic
  use_remote_gateways          = each.value.use_remote_gateways
  allow_gateway_transit        = each.value.allow_gateway_transit

  depends_on = [
    module.module_azurerm_resource_group_template_deployment["sdwan_workshop_ars"].resource_group_template_deployment
  ]
}

output "virtual_network_peerings" {
  value = var.enable_module_output ? module.module_azurerm_virtual_network_peering[*] : null
}
