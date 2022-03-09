locals {

  lb_probes = {
    # Hub 1 LB Probe
    "lb_probe_hub1_ext_lb_01" = { name = "lb_probe_hub1_ext_lb_01", loadbalancer_id = "lb_hub1_ext_01", port = "8008" }

    # Branch 1 LB Probe
    "lb_probe_br1_ext_lb_01" = { name = "lb_probe_br1_ext_lb_01", loadbalancer_id = "lb_branch1_ext_01", port = "8008" }
    "lb_probe_br1_int_lb_01" = { name = "lb_probe_br1_int_lb_01", loadbalancer_id = "lb_branch1_int_01", port = "8008" }

    # Branch 2 LB Probe
    "lb_probe_br2_ext_lb_01" = { name = "lb_probe_br2_ext_lb_01", loadbalancer_id = "lb_branch2_ext_01", port = "8008" }
    "lb_probe_br2_int_lb_01" = { name = "lb_probe_br2_int_lb_01", loadbalancer_id = "lb_branch2_int_01", port = "8008" }

  }
}

module "module_azurerm_lb_probe" {
  for_each = local.lb_probes

  source = "../azure/rm/azurerm_lb_probe"

  resource_group_name = module.module_azurerm_resource_group.resource_group.name

  name            = each.value.name
  loadbalancer_id = module.module_azurerm_lb[each.value.loadbalancer_id].lb.id
  port            = each.value.port
}

output "lb_probes" {
  value = module.module_azurerm_lb_probe[*]
}
