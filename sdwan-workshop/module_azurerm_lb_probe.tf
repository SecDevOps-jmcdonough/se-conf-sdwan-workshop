module "module_azurerm_lb_probe" {
  for_each = local.lb_probes

  source = "../azure/rm/azurerm_lb_probe"

  resource_group_name = each.value.resource_group_name

  name            = each.value.name
  loadbalancer_id = each.value.loadbalancer_id
  port            = each.value.port
}

output "lb_probes" {
  value = var.enable_module_output ? module.module_azurerm_lb_probe[*] : null
}
