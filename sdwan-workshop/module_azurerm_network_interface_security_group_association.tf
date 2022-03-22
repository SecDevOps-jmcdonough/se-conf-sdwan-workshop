locals {
  network_interface_security_group_associations = {
    # Hub
    "nic_hub1_fortigate_1_1" = { network_interface_id = module.module_azurerm_network_interface["nic_hub1_fortigate_1_1"].network_interface.id, network_security_group_id = module.module_azurerm_network_security_group["nsg_pub"].network_security_group.id }
    "nic_hub1_fortigate_1_2" = { network_interface_id = module.module_azurerm_network_interface["nic_hub1_fortigate_1_2"].network_interface.id, network_security_group_id = module.module_azurerm_network_security_group["nsg_priv"].network_security_group.id }
    "nic_hub1_fortigate_1_3" = { network_interface_id = module.module_azurerm_network_interface["nic_hub1_fortigate_1_3"].network_interface.id, network_security_group_id = module.module_azurerm_network_security_group["nsg_priv"].network_security_group.id }
    "nic_hub1_fortigate_1_4" = { network_interface_id = module.module_azurerm_network_interface["nic_hub1_fortigate_1_4"].network_interface.id, network_security_group_id = module.module_azurerm_network_security_group["nsg_pub"].network_security_group.id }

    "nic_hub1_fortigate_2_1" = { network_interface_id = module.module_azurerm_network_interface["nic_hub1_fortigate_2_1"].network_interface.id, network_security_group_id = module.module_azurerm_network_security_group["nsg_pub"].network_security_group.id }
    "nic_hub1_fortigate_2_2" = { network_interface_id = module.module_azurerm_network_interface["nic_hub1_fortigate_2_2"].network_interface.id, network_security_group_id = module.module_azurerm_network_security_group["nsg_priv"].network_security_group.id }
    "nic_hub1_fortigate_2_3" = { network_interface_id = module.module_azurerm_network_interface["nic_hub1_fortigate_2_3"].network_interface.id, network_security_group_id = module.module_azurerm_network_security_group["nsg_priv"].network_security_group.id }
    "nic_hub1_fortigate_2_4" = { network_interface_id = module.module_azurerm_network_interface["nic_hub1_fortigate_2_4"].network_interface.id, network_security_group_id = module.module_azurerm_network_security_group["nsg_pub"].network_security_group.id }

    # Branch 1
    "nic_br1_fortigate_1_1" = { network_interface_id = module.module_azurerm_network_interface["nic_br1_fortigate_1_1"].network_interface.id, network_security_group_id = module.module_azurerm_network_security_group["nsg_br1"].network_security_group.id }
    "nic_br1_fortigate_1_2" = { network_interface_id = module.module_azurerm_network_interface["nic_br1_fortigate_1_2"].network_interface.id, network_security_group_id = module.module_azurerm_network_security_group["nsg_br1"].network_security_group.id }
    "nic_br1_fortigate_1_3" = { network_interface_id = module.module_azurerm_network_interface["nic_br1_fortigate_1_3"].network_interface.id, network_security_group_id = module.module_azurerm_network_security_group["nsg_br1"].network_security_group.id }
    "nic_br1_fortigate_1_4" = { network_interface_id = module.module_azurerm_network_interface["nic_br1_fortigate_1_4"].network_interface.id, network_security_group_id = module.module_azurerm_network_security_group["nsg_br1"].network_security_group.id }
    "nic_br1_fortigate_1_5" = { network_interface_id = module.module_azurerm_network_interface["nic_br1_fortigate_1_5"].network_interface.id, network_security_group_id = module.module_azurerm_network_security_group["nsg_br1"].network_security_group.id }

    "nic_br1_fortigate_2_1" = { network_interface_id = module.module_azurerm_network_interface["nic_br1_fortigate_2_1"].network_interface.id, network_security_group_id = module.module_azurerm_network_security_group["nsg_br1"].network_security_group.id }
    "nic_br1_fortigate_2_2" = { network_interface_id = module.module_azurerm_network_interface["nic_br1_fortigate_2_2"].network_interface.id, network_security_group_id = module.module_azurerm_network_security_group["nsg_br1"].network_security_group.id }
    "nic_br1_fortigate_2_3" = { network_interface_id = module.module_azurerm_network_interface["nic_br1_fortigate_2_3"].network_interface.id, network_security_group_id = module.module_azurerm_network_security_group["nsg_br1"].network_security_group.id }
    "nic_br1_fortigate_2_4" = { network_interface_id = module.module_azurerm_network_interface["nic_br1_fortigate_2_4"].network_interface.id, network_security_group_id = module.module_azurerm_network_security_group["nsg_br1"].network_security_group.id }
    "nic_br1_fortigate_2_5" = { network_interface_id = module.module_azurerm_network_interface["nic_br1_fortigate_2_5"].network_interface.id, network_security_group_id = module.module_azurerm_network_security_group["nsg_br1"].network_security_group.id }

    # Branch 2
    "nic_br2_fortigate_1_1" = { network_interface_id = module.module_azurerm_network_interface["nic_br2_fortigate_1_1"].network_interface.id, network_security_group_id = module.module_azurerm_network_security_group["nsg_br2"].network_security_group.id }
    "nic_br2_fortigate_1_2" = { network_interface_id = module.module_azurerm_network_interface["nic_br2_fortigate_1_2"].network_interface.id, network_security_group_id = module.module_azurerm_network_security_group["nsg_br2"].network_security_group.id }
    "nic_br2_fortigate_1_3" = { network_interface_id = module.module_azurerm_network_interface["nic_br2_fortigate_1_3"].network_interface.id, network_security_group_id = module.module_azurerm_network_security_group["nsg_br2"].network_security_group.id }
    "nic_br2_fortigate_1_4" = { network_interface_id = module.module_azurerm_network_interface["nic_br2_fortigate_1_4"].network_interface.id, network_security_group_id = module.module_azurerm_network_security_group["nsg_br2"].network_security_group.id }
    "nic_br2_fortigate_1_5" = { network_interface_id = module.module_azurerm_network_interface["nic_br2_fortigate_1_5"].network_interface.id, network_security_group_id = module.module_azurerm_network_security_group["nsg_br2"].network_security_group.id }

    "nic_br2_fortigate_2_1" = { network_interface_id = module.module_azurerm_network_interface["nic_br2_fortigate_2_1"].network_interface.id, network_security_group_id = module.module_azurerm_network_security_group["nsg_br2"].network_security_group.id }
    "nic_br2_fortigate_2_2" = { network_interface_id = module.module_azurerm_network_interface["nic_br2_fortigate_2_2"].network_interface.id, network_security_group_id = module.module_azurerm_network_security_group["nsg_br2"].network_security_group.id }
    "nic_br2_fortigate_2_3" = { network_interface_id = module.module_azurerm_network_interface["nic_br2_fortigate_2_3"].network_interface.id, network_security_group_id = module.module_azurerm_network_security_group["nsg_br2"].network_security_group.id }
    "nic_br2_fortigate_2_4" = { network_interface_id = module.module_azurerm_network_interface["nic_br2_fortigate_2_4"].network_interface.id, network_security_group_id = module.module_azurerm_network_security_group["nsg_br2"].network_security_group.id }
    "nic_br2_fortigate_2_5" = { network_interface_id = module.module_azurerm_network_interface["nic_br2_fortigate_2_5"].network_interface.id, network_security_group_id = module.module_azurerm_network_security_group["nsg_br2"].network_security_group.id }

    # Branch 3
    "nic_br3_fortigate_1_1" = { network_interface_id = module.module_azurerm_network_interface["nic_br3_fortigate_1_1"].network_interface.id, network_security_group_id = module.module_azurerm_network_security_group["nsg_br3"].network_security_group.id }
    "nic_br3_fortigate_1_2" = { network_interface_id = module.module_azurerm_network_interface["nic_br3_fortigate_1_2"].network_interface.id, network_security_group_id = module.module_azurerm_network_security_group["nsg_br3"].network_security_group.id }
    "nic_br3_fortigate_1_3" = { network_interface_id = module.module_azurerm_network_interface["nic_br3_fortigate_1_3"].network_interface.id, network_security_group_id = module.module_azurerm_network_security_group["nsg_br3"].network_security_group.id }
  }
}

module "module_azurerm_network_interface_security_group_association" {
  for_each = local.network_interface_security_group_associations

  source = "../azure/rm/azurerm_network_interface_security_group_association"

  network_interface_id      = each.value.network_interface_id
  network_security_group_id = each.value.network_security_group_id
}

output "network_interface_security_group_associations" {
  value = module.module_azurerm_network_interface_security_group_association[*]
}
