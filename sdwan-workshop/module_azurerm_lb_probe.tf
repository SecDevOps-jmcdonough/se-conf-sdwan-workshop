locals {

  lb_probes = {
    # Hub 1
    "lb_probe_hub1_ext_lb_01" = { resource_group_name = module.module_azurerm_resource_group.resource_group.name, name = "lb_probe_hub1_ext_lb_01", loadbalancer_id = module.module_azurerm_lb["lb_hub1_ext_01"].lb.id, port = "8008" }

    # Branch 1
    "lb_probe_br1_ext_lb_01" = { resource_group_name = module.module_azurerm_resource_group.resource_group.name, name = "lb_probe_br1_ext_lb_01", loadbalancer_id = module.module_azurerm_lb["lb_branch1_ext_01"].lb.id, port = "8008" }
    "lb_probe_br1_int_lb_01" = { resource_group_name = module.module_azurerm_resource_group.resource_group.name, name = "lb_probe_br1_int_lb_01", loadbalancer_id = module.module_azurerm_lb["lb_branch1_int_01"].lb.id, port = "8008" }

    # Branch 2
    "lb_probe_br2_ext_lb_01" = { resource_group_name = module.module_azurerm_resource_group.resource_group.name, name = "lb_probe_br2_ext_lb_01", loadbalancer_id = module.module_azurerm_lb["lb_branch2_ext_01"].lb.id, port = "8008" }
    "lb_probe_br2_int_lb_01" = { resource_group_name = module.module_azurerm_resource_group.resource_group.name, name = "lb_probe_br2_int_lb_01", loadbalancer_id = module.module_azurerm_lb["lb_branch2_int_01"].lb.id, port = "8008" }

  }
}

module "module_azurerm_lb_probe" {
  for_each = local.lb_probes

  source = "../azure/rm/azurerm_lb_probe"

  resource_group_name = each.value.resource_group_name

  name            = each.value.name
  loadbalancer_id = each.value.loadbalancer_id
  port            = each.value.port
}

output "lb_probes" {
  value = module.module_azurerm_lb_probe[*]
}
