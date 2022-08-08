locals {

  project = var.project
  event   = var.event

  project_event = "${local.project}_${local.event}"

  resource_group_name     = "${var.student}_${local.project_event}"
  resource_group_location = var.resource_group_location
  rg_exists               = var.rg_exists

  resource_groups = {
    (local.resource_group_name) = {
      name     = local.resource_group_name
      location = local.resource_group_location
    }
  }

  resource_group_data_name     = local.rg_exists ? data.azurerm_resource_group.resource_group.0.name : module.module_azurerm_resource_group[0].resource_group.name
  resource_group_data_location = local.rg_exists ? data.azurerm_resource_group.resource_group.0.location : module.module_azurerm_resource_group[0].resource_group.location
  resource_group_data_id       = local.rg_exists ? data.azurerm_resource_group.resource_group.0.id : module.module_azurerm_resource_group[0].resource_group.id

  tags = {
    Project = local.project
    Event   = local.event
  }


  public_ips                                          = merge(local.hub_public_ips, local.branch_public_ips)
  virtual_networks                                    = merge(local.hub_virtual_networks, local.branch_virtual_networks, local.spoke_virtual_networks)
  subnets                                             = merge(local.hub_subnets, local.branch_subnets, local.spoke_subnets)
  virtual_network_peerings                            = merge(local.hub_virtual_network_peerings, local.spoke_virtual_network_peerings)
  network_interfaces                                  = merge(local.hub_network_interfaces, local.branch_network_interfaces, local.spoke_network_interfaces)
  availability_sets                                   = merge(local.hub_availability_sets, local.branch_availability_sets)
  storage_accounts                                    = merge(local.hub_storage_accounts, local.branch_storage_accounts, local.spoke_storage_accounts)
  lb_backend_address_pools                            = merge(local.hub_lb_backend_address_pools, local.branch_lb_backend_address_pools)
  lb_nat_rules                                        = merge(local.hub_lb_nat_rules, local.branch_lb_nat_rules)
  lb_outbound_rules                                   = merge(local.hub_lb_outbound_rules, local.branch_lb_outbound_rules)
  lb_probes                                           = merge(local.hub_lb_probes, local.branch_lb_probes)
  lb_rules                                            = merge(local.hub_lb_rules, local.branch_lb_rules)
  lbs                                                 = merge(local.hub_lbs, local.branch_lbs)
  network_interface_backend_address_pool_associations = merge(local.hub_network_interface_backend_address_pool_associations, local.branch_network_interface_backend_address_pool_associations)
  network_interface_nat_rule_associations             = merge(local.hub_network_interface_nat_rule_associations, local.branch_network_interface_nat_rule_associations)
  network_security_groups                             = merge(local.hub_network_security_groups, local.branch_network_security_groups)
  network_security_rules                              = merge(local.hub_network_security_rules, local.branch_network_security_rules)
  subnet_network_security_group_associations          = merge(local.hub_subnet_network_security_group_associations, local.branch_subnet_network_security_group_associations)
  route_tables                                        = merge(local.hub_route_tables, local.branch_route_tables)
  subnet_route_table_associations                     = merge(local.hub_subnet_route_table_associations, local.branch_subnet_route_table_associations)
  linux_virtual_machines                              = merge(local.branch_linux_virtual_machines, local.spoke_linux_virtual_machines)
  virtual_machines                                    = merge(local.hub_virtual_machines, local.branch_virtual_machines)
  role_assignments                                    = merge(local.hub_role_assignments, local.branch_role_assignments)

  vm_linux_image = {
    "Canonical" = {
      publisher = "Canonical"
      offer     = "UbuntuServer"
      sku       = "18.04-LTS"
      version   = "latest"
    }
  }

  vm_image = {
    "fortinet" = {
      publisher = "fortinet"
      offer     = "fortinet_fortigate-vm_v5"
      sku       = "fortinet_fg-vm_payg_2022"
      version   = "7.0.5"
    }
  }
}