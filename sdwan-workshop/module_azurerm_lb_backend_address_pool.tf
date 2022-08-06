module "module_azurerm_lb_backend_address_pool" {
  for_each = local.lb_backend_address_pools

  source = "../azure/rm/azurerm_lb_backend_address_pool"

  name            = each.value.name
  loadbalancer_id = each.value.loadbalancer_id
}

output "lb_backend_address_pools" {
  value = var.enable_module_output ? module.module_azurerm_lb_backend_address_pool[*] : null
}
