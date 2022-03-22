locals {
  lb_nat_rules = {

    # Hub 1
    "hub1_fgt1_https" = { name = "hub1_fgt1_https", loadbalancer_id = module.module_azurerm_lb["lb_hub1_ext_01"].lb.id, protocol = "Tcp", frontend_port = "1443", backend_port = "34443", frontend_ip_configuration_name = "pip_hub_elb_01" }
    "hub1_fgt2_https" = { name = "hub1_fgt2_https", loadbalancer_id = module.module_azurerm_lb["lb_hub1_ext_01"].lb.id, protocol = "Tcp", frontend_port = "2443", backend_port = "34443", frontend_ip_configuration_name = "pip_hub_elb_01" }
    "hub1_fgt1_ssh"   = { name = "hub1_fgt1_ssh", loadbalancer_id = module.module_azurerm_lb["lb_hub1_ext_01"].lb.id, protocol = "Tcp", frontend_port = "1422", backend_port = "3422", frontend_ip_configuration_name = "pip_hub_elb_01" }
    "hub1_fgt2_ssh"   = { name = "hub1_fgt2_ssh", loadbalancer_id = module.module_azurerm_lb["lb_hub1_ext_01"].lb.id, protocol = "Tcp", frontend_port = "2422", backend_port = "3422", frontend_ip_configuration_name = "pip_hub_elb_01" }

    # Branch 1
    "br1_fgt1_https" = { name = "br1_fgt1_https", loadbalancer_id = module.module_azurerm_lb["lb_branch1_ext_01"].lb.id, protocol = "Tcp", frontend_port = "1443", backend_port = "34443", frontend_ip_configuration_name = "pip_br1_elb_01" }
    "br1_fgt2_https" = { name = "br1_fgt2_https", loadbalancer_id = module.module_azurerm_lb["lb_branch1_ext_01"].lb.id, protocol = "Tcp", frontend_port = "2443", backend_port = "34443", frontend_ip_configuration_name = "pip_br1_elb_01" }
    "br1_fgt1_ssh"   = { name = "br1_fgt1_ssh", loadbalancer_id = module.module_azurerm_lb["lb_branch1_ext_01"].lb.id, protocol = "Tcp", frontend_port = "1422", backend_port = "3422", frontend_ip_configuration_name = "pip_br1_elb_01" }
    "br1_fgt2_ssh"   = { name = "br1_fgt2_ssh", loadbalancer_id = module.module_azurerm_lb["lb_branch1_ext_01"].lb.id, protocol = "Tcp", frontend_port = "2422", backend_port = "3422", frontend_ip_configuration_name = "pip_br1_elb_01" }

    # Branch 2
    "br2_fgt1_https" = { name = "br2_fgt1_https", loadbalancer_id = module.module_azurerm_lb["lb_branch2_ext_01"].lb.id, protocol = "Tcp", frontend_port = "1443", backend_port = "34443", frontend_ip_configuration_name = "pip_br2_elb_01" }
    "br2_fgt2_https" = { name = "br2_fgt2_https", loadbalancer_id = module.module_azurerm_lb["lb_branch2_ext_01"].lb.id, protocol = "Tcp", frontend_port = "2443", backend_port = "34443", frontend_ip_configuration_name = "pip_br2_elb_01" }
    "br2_fgt1_ssh"   = { name = "br2_fgt1_ssh", loadbalancer_id = module.module_azurerm_lb["lb_branch2_ext_01"].lb.id, protocol = "Tcp", frontend_port = "1422", backend_port = "3422", frontend_ip_configuration_name = "pip_br2_elb_01" }
    "br2_fgt2_ssh"   = { name = "br2_fgt2_ssh", loadbalancer_id = module.module_azurerm_lb["lb_branch2_ext_01"].lb.id, protocol = "Tcp", frontend_port = "2422", backend_port = "3422", frontend_ip_configuration_name = "pip_br2_elb_01" }
  }
}

module "module_azurerm_lb_nat_rule" {
  for_each = local.lb_nat_rules

  source = "../azure/rm/azurerm_lb_nat_rule"

  resource_group_name = module.module_azurerm_resource_group.resource_group.name

  name                           = each.value.name
  loadbalancer_id                = each.value.loadbalancer_id
  protocol                       = each.value.protocol
  frontend_port                  = each.value.frontend_port
  backend_port                   = each.value.backend_port
  frontend_ip_configuration_name = each.value.frontend_ip_configuration_name

}

output "lb_nat_rules" {
  value = module.module_azurerm_lb_nat_rule[*]
}