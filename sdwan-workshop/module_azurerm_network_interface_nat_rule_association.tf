locals {
  network_interface_nat_rule_associations = {

    # Hub 1 External LB Nat
    "hub1_fgt1_https" = { network_interface_id = "nic_hub1_fortigate_1_4", ip_configuration_name = "ipconfig1", nat_rule_id = "hub1_fgt1_https" }
    "hub1_fgt2_https" = { network_interface_id = "nic_hub1_fortigate_2_4", ip_configuration_name = "ipconfig1", nat_rule_id = "hub1_fgt2_https" }
    "hub1_fgt1_ssh"   = { network_interface_id = "nic_hub1_fortigate_1_4", ip_configuration_name = "ipconfig1", nat_rule_id = "hub1_fgt1_ssh" }
    "hub1_fgt2_ssh"   = { network_interface_id = "nic_hub1_fortigate_2_4", ip_configuration_name = "ipconfig1", nat_rule_id = "hub1_fgt2_ssh" }

    # Branch 1 External LB
    "br1_fgt1_https" = { network_interface_id = "nic_br1_fortigate_1_5", ip_configuration_name = "ipconfig1", nat_rule_id = "br1_fgt1_https" }
    "br1_fgt2_https" = { network_interface_id = "nic_br1_fortigate_2_5", ip_configuration_name = "ipconfig1", nat_rule_id = "br1_fgt2_https" }
    "br1_fgt1_ssh"   = { network_interface_id = "nic_br1_fortigate_1_5", ip_configuration_name = "ipconfig1", nat_rule_id = "br1_fgt1_ssh" }
    "br1_fgt2_ssh"   = { network_interface_id = "nic_br1_fortigate_2_5", ip_configuration_name = "ipconfig1", nat_rule_id = "br1_fgt2_ssh" }

    # Branch 2 External LB
    "br2_fgt1_https" = { network_interface_id = "nic_br2_fortigate_1_5", ip_configuration_name = "ipconfig1", nat_rule_id = "br2_fgt1_https" }
    "br2_fgt2_https" = { network_interface_id = "nic_br2_fortigate_2_5", ip_configuration_name = "ipconfig1", nat_rule_id = "br2_fgt2_https" }
    "br2_fgt1_ssh"   = { network_interface_id = "nic_br2_fortigate_1_5", ip_configuration_name = "ipconfig1", nat_rule_id = "br2_fgt1_ssh" }
    "br2_fgt2_ssh"   = { network_interface_id = "nic_br2_fortigate_2_5", ip_configuration_name = "ipconfig1", nat_rule_id = "br2_fgt2_ssh" }
  }
}

module "module_azurerm_network_interface_nat_rule_association" {
  for_each = local.network_interface_nat_rule_associations

  source = "../azure/rm/azurerm_network_interface_nat_rule_association"

  network_interface_id  = module.module_azurerm_network_interface[each.value.network_interface_id].network_interface.id
  ip_configuration_name = each.value.ip_configuration_name
  nat_rule_id           = module.module_azurerm_lb_nat_rule[each.value.nat_rule_id].lb_nat_rule.id
}

output "network_interface_nat_rule_associations" {
  value = module.module_azurerm_network_interface_nat_rule_association[*]
}
