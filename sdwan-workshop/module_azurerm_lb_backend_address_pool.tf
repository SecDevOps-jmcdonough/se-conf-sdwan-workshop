locals {
  lb_backend_address_pools = {
    # Hub 1
    "lb_pool_01_hub1_ext_01" = { name = "lb_pool_01_hub1_ext_01", loadbalancer_id = module.module_azurerm_lb["lb_hub1_ext_01"].lb.id }

    # Branch 1
    "lb_pool_br1_ext_01_01" = { name = "lb_pool_br1_ext_01_01", loadbalancer_id = module.module_azurerm_lb["lb_branch1_ext_01"].lb.id }
    "lb_pool_br1_ext_01_02" = { name = "lb_pool_br1_ext_01_02", loadbalancer_id = module.module_azurerm_lb["lb_branch1_ext_01"].lb.id }
    "lb_pool_br1_int_01_01" = { name = "lb_pool_br1_int_01_01", loadbalancer_id = module.module_azurerm_lb["lb_branch1_int_01"].lb.id }

    # Branch 2
    "lb_pool_br2_ext_01_01" = { name = "llb_pool_br2_ext_01_01", loadbalancer_id = module.module_azurerm_lb["lb_branch2_ext_01"].lb.id }
    "lb_pool_br2_ext_01_02" = { name = "llb_pool_br2_ext_01_02", loadbalancer_id = module.module_azurerm_lb["lb_branch2_ext_01"].lb.id }
    "lb_pool_br2_int_01_01" = { name = "llb_pool_br2_int_01_01", loadbalancer_id = module.module_azurerm_lb["lb_branch2_int_01"].lb.id }

  }
}

module "module_azurerm_lb_backend_address_pool" {
  for_each = local.lb_backend_address_pools

  source = "../azure/rm/azurerm_lb_backend_address_pool"

  name            = each.value.name
  loadbalancer_id = each.value.loadbalancer_id
}

output "lb_backend_address_pools" {
  value = module.module_azurerm_lb_backend_address_pool[*]
}
