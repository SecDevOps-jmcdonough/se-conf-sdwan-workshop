locals {
  network_interface_nat_rule_associations = {

    # Hub 1
    "hub1_fgt1_https" = { network_interface_id = module.module_azurerm_network_interface["nic_hub1_fortigate_1_4"].network_interface.id, ip_configuration_name = "ipconfig1", nat_rule_id = module.module_azurerm_lb_nat_rule["hub1_fgt1_https"].lb_nat_rule.id }
    "hub1_fgt2_https" = { network_interface_id = module.module_azurerm_network_interface["nic_hub1_fortigate_2_4"].network_interface.id, ip_configuration_name = "ipconfig1", nat_rule_id = module.module_azurerm_lb_nat_rule["hub1_fgt2_https"].lb_nat_rule.id }
    "hub1_fgt1_ssh"   = { network_interface_id = module.module_azurerm_network_interface["nic_hub1_fortigate_1_4"].network_interface.id, ip_configuration_name = "ipconfig1", nat_rule_id = module.module_azurerm_lb_nat_rule["hub1_fgt1_ssh"].lb_nat_rule.id }
    "hub1_fgt2_ssh"   = { network_interface_id = module.module_azurerm_network_interface["nic_hub1_fortigate_2_4"].network_interface.id, ip_configuration_name = "ipconfig1", nat_rule_id = module.module_azurerm_lb_nat_rule["hub1_fgt2_ssh"].lb_nat_rule.id }

    # Branch 1
    "br1_fgt1_https" = { network_interface_id = module.module_azurerm_network_interface["nic_br1_fortigate_1_5"].network_interface.id, ip_configuration_name = "ipconfig1", nat_rule_id = module.module_azurerm_lb_nat_rule["br1_fgt1_https"].lb_nat_rule.id }
    "br1_fgt2_https" = { network_interface_id = module.module_azurerm_network_interface["nic_br1_fortigate_2_5"].network_interface.id, ip_configuration_name = "ipconfig1", nat_rule_id = module.module_azurerm_lb_nat_rule["br1_fgt2_https"].lb_nat_rule.id }
    "br1_fgt1_ssh"   = { network_interface_id = module.module_azurerm_network_interface["nic_br1_fortigate_1_5"].network_interface.id, ip_configuration_name = "ipconfig1", nat_rule_id = module.module_azurerm_lb_nat_rule["br1_fgt1_ssh"].lb_nat_rule.id }
    "br1_fgt2_ssh"   = { network_interface_id = module.module_azurerm_network_interface["nic_br1_fortigate_2_5"].network_interface.id, ip_configuration_name = "ipconfig1", nat_rule_id = module.module_azurerm_lb_nat_rule["br1_fgt2_ssh"].lb_nat_rule.id }

    # Branch 2
    "br2_fgt1_https" = { network_interface_id = module.module_azurerm_network_interface["nic_br2_fortigate_1_5"].network_interface.id, ip_configuration_name = "ipconfig1", nat_rule_id = module.module_azurerm_lb_nat_rule["br2_fgt1_https"].lb_nat_rule.id }
    "br2_fgt2_https" = { network_interface_id = module.module_azurerm_network_interface["nic_br2_fortigate_2_5"].network_interface.id, ip_configuration_name = "ipconfig1", nat_rule_id = module.module_azurerm_lb_nat_rule["br2_fgt2_https"].lb_nat_rule.id }
    "br2_fgt1_ssh"   = { network_interface_id = module.module_azurerm_network_interface["nic_br2_fortigate_1_5"].network_interface.id, ip_configuration_name = "ipconfig1", nat_rule_id = module.module_azurerm_lb_nat_rule["br2_fgt1_ssh"].lb_nat_rule.id }
    "br2_fgt2_ssh"   = { network_interface_id = module.module_azurerm_network_interface["nic_br2_fortigate_2_5"].network_interface.id, ip_configuration_name = "ipconfig1", nat_rule_id = module.module_azurerm_lb_nat_rule["br2_fgt2_ssh"].lb_nat_rule.id }
  }
}

module "module_azurerm_network_interface_nat_rule_association" {
  for_each = local.network_interface_nat_rule_associations

  source = "../azure/rm/azurerm_network_interface_nat_rule_association"

  network_interface_id  = each.value.network_interface_id
  ip_configuration_name = each.value.ip_configuration_name
  nat_rule_id           = each.value.nat_rule_id
}

output "network_interface_nat_rule_associations" {
  value = module.module_azurerm_network_interface_nat_rule_association[*]
}
