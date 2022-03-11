locals {
  network_interface_backend_address_pool_associations = {

    # Hub 1

    # Branch 1
    "nic_br1_fortigate_1_1" = { network_interface_id = "nic_br1_fortigate_1_1", ip_configuration_name = "ipconfig1", backend_address_pool_id = "lb_pool_br1_ext_01_01" }
    "nic_br1_fortigate_1_2" = { network_interface_id = "nic_br1_fortigate_1_2", ip_configuration_name = "ipconfig1", backend_address_pool_id = "lb_pool_br1_int_01_01" }
    "nic_br1_fortigate_1_3" = { network_interface_id = "nic_br1_fortigate_1_3", ip_configuration_name = "ipconfig1", backend_address_pool_id = "lb_pool_br1_ext_01_02" }
    "nic_br1_fortigate_2_1" = { network_interface_id = "nic_br1_fortigate_2_1", ip_configuration_name = "ipconfig1", backend_address_pool_id = "lb_pool_br1_ext_01_01" }
    "nic_br1_fortigate_2_2" = { network_interface_id = "nic_br1_fortigate_2_2", ip_configuration_name = "ipconfig1", backend_address_pool_id = "lb_pool_br1_int_01_01" }
    "nic_br1_fortigate_2_3" = { network_interface_id = "nic_br1_fortigate_2_3", ip_configuration_name = "ipconfig1", backend_address_pool_id = "lb_pool_br1_ext_01_02" }

    # Branch 2
    "nic_br2_fortigate_1_1" = { network_interface_id = "nic_br2_fortigate_1_1", ip_configuration_name = "ipconfig1", backend_address_pool_id = "lb_pool_br2_ext_01_01" }
    "nic_br2_fortigate_1_2" = { network_interface_id = "nic_br2_fortigate_1_2", ip_configuration_name = "ipconfig1", backend_address_pool_id = "lb_pool_br2_int_01_01" }
    "nic_br2_fortigate_1_3" = { network_interface_id = "nic_br2_fortigate_1_3", ip_configuration_name = "ipconfig1", backend_address_pool_id = "lb_pool_br2_ext_01_02" }
    "nic_br2_fortigate_2_1" = { network_interface_id = "nic_br2_fortigate_2_1", ip_configuration_name = "ipconfig1", backend_address_pool_id = "lb_pool_br2_ext_01_01" }
    "nic_br2_fortigate_2_2" = { network_interface_id = "nic_br2_fortigate_2_2", ip_configuration_name = "ipconfig1", backend_address_pool_id = "lb_pool_br2_int_01_01" }
    "nic_br2_fortigate_2_3" = { network_interface_id = "nic_br2_fortigate_2_3", ip_configuration_name = "ipconfig1", backend_address_pool_id = "lb_pool_br2_ext_01_02" }
  }
}

module "module_azurerm_network_interface_backend_address_pool_association" {
  for_each = local.network_interface_backend_address_pool_associations

  source = "../azure/rm/azurerm_network_interface_backend_address_pool_association"

  network_interface_id    = module.module_azurerm_network_interface[each.value.network_interface_id].network_interface.id
  ip_configuration_name   = each.value.ip_configuration_name
  backend_address_pool_id = module.module_azurerm_lb_backend_address_pool[each.value.backend_address_pool_id].lb_backend_address_pool.id
}

output "network_interface_backend_address_pool_association" {
  value = module.module_azurerm_network_interface_backend_address_pool_association[*]
}
