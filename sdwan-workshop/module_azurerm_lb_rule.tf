locals {
  lb_rules = {
    # Hub

    # Branches
    "lb_rule_br1_int_fgt_haports"   = { resource_group_name = module.module_azurerm_resource_group.resource_group.name, name = "lb_rule_br1_int_fgt_haports", loadbalancer_id = module.module_azurerm_lb["lb_branch1_int_01"].lb.id, frontend_ip_configuration_name = "lb_branch1_int_fe_ip_01", protocol = "All", frontend_port = "0", backend_port = "0", backend_address_pool_ids = [module.module_azurerm_lb_backend_address_pool["lb_pool_br1_int_01_01"].lb_backend_address_pool.id], probe_id = module.module_azurerm_lb_probe["lb_probe_br1_int_lb_01"].lb_probe.id, disable_outbound_snat = true }
    "lb_rule_br2_int_fgt_haports"   = { resource_group_name = module.module_azurerm_resource_group.resource_group.name, name = "lb_rule_br2_int_fgt_haports", loadbalancer_id = module.module_azurerm_lb["lb_branch2_int_01"].lb.id, frontend_ip_configuration_name = "lb_branch2_int_fe_ip_01", protocol = "All", frontend_port = "0", backend_port = "0", backend_address_pool_ids = [module.module_azurerm_lb_backend_address_pool["lb_pool_br2_int_01_01"].lb_backend_address_pool.id], probe_id = module.module_azurerm_lb_probe["lb_probe_br2_int_lb_01"].lb_probe.id, disable_outbound_snat = true }
    "lb_rule_br1_ext_udp_500_isp1"  = { resource_group_name = module.module_azurerm_resource_group.resource_group.name, name = "lb_rule_br1_ext_udp_500_isp1", loadbalancer_id = module.module_azurerm_lb["lb_branch1_ext_01"].lb.id, frontend_ip_configuration_name = "pip_br1_elb_01", protocol = "Udp", frontend_port = "500", backend_port = "500", backend_address_pool_ids = [module.module_azurerm_lb_backend_address_pool["lb_pool_br1_ext_01_01"].lb_backend_address_pool.id], probe_id = module.module_azurerm_lb_probe["lb_probe_br1_ext_lb_01"].lb_probe.id, disable_outbound_snat = true }
    "lb_rule_br1_ext_udp_4500_isp1" = { resource_group_name = module.module_azurerm_resource_group.resource_group.name, name = "lb_rule_br1_ext_udp_4500_isp1", loadbalancer_id = module.module_azurerm_lb["lb_branch1_ext_01"].lb.id, frontend_ip_configuration_name = "pip_br1_elb_01", protocol = "Udp", frontend_port = "4500", backend_port = "4500", backend_address_pool_ids = [module.module_azurerm_lb_backend_address_pool["lb_pool_br1_ext_01_01"].lb_backend_address_pool.id], probe_id = module.module_azurerm_lb_probe["lb_probe_br1_ext_lb_01"].lb_probe.id, disable_outbound_snat = true }
    "lb_rule_br1_ext_udp_500_isp2"  = { resource_group_name = module.module_azurerm_resource_group.resource_group.name, name = "lb_rule_br1_ext_udp_500_isp2", loadbalancer_id = module.module_azurerm_lb["lb_branch1_ext_01"].lb.id, frontend_ip_configuration_name = "pip_br1_elb_02", protocol = "Udp", frontend_port = "500", backend_port = "500", backend_address_pool_ids = [module.module_azurerm_lb_backend_address_pool["lb_pool_br1_ext_01_02"].lb_backend_address_pool.id], probe_id = module.module_azurerm_lb_probe["lb_probe_br1_ext_lb_01"].lb_probe.id, disable_outbound_snat = true }
    "lb_rule_br1_ext_udp_4500_isp2" = { resource_group_name = module.module_azurerm_resource_group.resource_group.name, name = "lb_rule_br1_ext_udp_4500_isp2", loadbalancer_id = module.module_azurerm_lb["lb_branch1_ext_01"].lb.id, frontend_ip_configuration_name = "pip_br1_elb_02", protocol = "Udp", frontend_port = "4500", backend_port = "4500", backend_address_pool_ids = [module.module_azurerm_lb_backend_address_pool["lb_pool_br1_ext_01_02"].lb_backend_address_pool.id], probe_id = module.module_azurerm_lb_probe["lb_probe_br1_ext_lb_01"].lb_probe.id, disable_outbound_snat = true }
    "lb_rule_br2_ext_udp_500_isp1"  = { resource_group_name = module.module_azurerm_resource_group.resource_group.name, name = "lb_rule_br2_ext_udp_500_isp1", loadbalancer_id = module.module_azurerm_lb["lb_branch2_ext_01"].lb.id, frontend_ip_configuration_name = "pip_br2_elb_01", protocol = "Udp", frontend_port = "500", backend_port = "500", backend_address_pool_ids = [module.module_azurerm_lb_backend_address_pool["lb_pool_br2_ext_01_01"].lb_backend_address_pool.id], probe_id = module.module_azurerm_lb_probe["lb_probe_br2_ext_lb_01"].lb_probe.id, disable_outbound_snat = true }
    "lb_rule_br2_ext_udp_4500_isp1" = { resource_group_name = module.module_azurerm_resource_group.resource_group.name, name = "lb_rule_br2_ext_udp_4500_isp1", loadbalancer_id = module.module_azurerm_lb["lb_branch2_ext_01"].lb.id, frontend_ip_configuration_name = "pip_br2_elb_01", protocol = "Udp", frontend_port = "4500", backend_port = "4500", backend_address_pool_ids = [module.module_azurerm_lb_backend_address_pool["lb_pool_br2_ext_01_01"].lb_backend_address_pool.id], probe_id = module.module_azurerm_lb_probe["lb_probe_br2_ext_lb_01"].lb_probe.id, disable_outbound_snat = true }
    "lb_rule_br2_ext_udp_500_isp2"  = { resource_group_name = module.module_azurerm_resource_group.resource_group.name, name = "lb_rule_br2_ext_udp_500_isp2", loadbalancer_id = module.module_azurerm_lb["lb_branch2_ext_01"].lb.id, frontend_ip_configuration_name = "pip_br2_elb_02", protocol = "Udp", frontend_port = "500", backend_port = "500", backend_address_pool_ids = [module.module_azurerm_lb_backend_address_pool["lb_pool_br2_ext_01_02"].lb_backend_address_pool.id], probe_id = module.module_azurerm_lb_probe["lb_probe_br2_ext_lb_01"].lb_probe.id, disable_outbound_snat = true }
    "lb_rule_br2_ext_udp_4500_isp2" = { resource_group_name = module.module_azurerm_resource_group.resource_group.name, name = "lb_rule_br2_ext_udp_4500_isp2", loadbalancer_id = module.module_azurerm_lb["lb_branch2_ext_01"].lb.id, frontend_ip_configuration_name = "pip_br2_elb_02", protocol = "Udp", frontend_port = "4500", backend_port = "4500", backend_address_pool_ids = [module.module_azurerm_lb_backend_address_pool["lb_pool_br2_ext_01_02"].lb_backend_address_pool.id], probe_id = module.module_azurerm_lb_probe["lb_probe_br2_ext_lb_01"].lb_probe.id, disable_outbound_snat = true }
  }
}

module "module_azurerm_lb_rule" {
  for_each = local.lb_rules

  source = "../azure/rm/azurerm_lb_rule"

  resource_group_name = each.value.resource_group_name

  name                           = each.value.name
  loadbalancer_id                = each.value.loadbalancer_id
  frontend_ip_configuration_name = each.value.frontend_ip_configuration_name
  protocol                       = each.value.protocol
  frontend_port                  = each.value.frontend_port
  backend_port                   = each.value.backend_port
  backend_address_pool_ids       = each.value.backend_address_pool_ids
  probe_id                       = each.value.probe_id
  disable_outbound_snat          = each.value.disable_outbound_snat
}

output "lb_rules" {
  value = module.module_azurerm_lb_rule[*]
}
