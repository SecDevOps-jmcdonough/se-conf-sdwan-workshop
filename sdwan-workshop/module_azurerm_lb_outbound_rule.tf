locals {
  lb_outbound_rules = {
    # Hub

    # Branches
    "br1_lb_outbound_rule_01" = { name = "br1_lb_outbound_rule_01", loadbalancer_id = "lb_branch1_ext_01", protocol = "All", backend_address_pool_id = "lb_pool_br1_ext_01_01",
      frontend_ip_configurations = [
        {
          name = "pip_br1_elb_01"
        }
      ]
    }
    "br1_lb_outbound_rule_02" = { name = "br1_lb_outbound_rule_02", loadbalancer_id = "lb_branch1_ext_01", protocol = "All", backend_address_pool_id = "lb_pool_br1_ext_01_02",
      frontend_ip_configurations = [
        {
          name = "pip_br1_elb_02"
        }
      ]
    }
    "br2_lb_outbound_rule_01" = { name = "br2_lb_outbound_rule_01", loadbalancer_id = "lb_branch2_ext_01", protocol = "All", backend_address_pool_id = "lb_pool_br2_ext_01_01",
      frontend_ip_configurations = [
        {
          name = "pip_br2_elb_01"
        }
      ]
    }
    "br2_lb_outbound_rule_02" = { name = "br2_lb_outbound_rule_02", loadbalancer_id = "lb_branch2_ext_01", protocol = "All", backend_address_pool_id = "lb_pool_br2_ext_01_02",
      frontend_ip_configurations = [
        {
          name = "pip_br2_elb_02"
        }
      ]
    }
  }
}

module "module_azurerm_lb_outbound_rule" {
  for_each = local.lb_outbound_rules

  source = "../azure/rm/azurerm_lb_outbound_rule"

  resource_group_name = module.module_azurerm_resource_group.resource_group.name

  name                       = each.value.name
  loadbalancer_id            = module.module_azurerm_lb[each.value.loadbalancer_id].lb.id
  backend_address_pool_id    = module.module_azurerm_lb_backend_address_pool[each.value.backend_address_pool_id].lb_backend_address_pool.id
  protocol                   = each.value.protocol
  frontend_ip_configurations = each.value.frontend_ip_configurations

}

output "lb_outbound_rules" {
  value = module.module_azurerm_lb_outbound_rule[*]
}
