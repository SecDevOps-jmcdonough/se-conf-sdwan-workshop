locals {
  hub_virtual_networks = {
    "vnet_hub1" = { resource_group_name = module.module_azurerm_resource_group.resource_group.name, location = "eastus", name = "vnet_hub1", address_space = ["10.10.0.0/16"] }
  }

  hub_subnets = {
    "hub1_fgt_public"   = { resource_group_name = module.module_azurerm_resource_group.resource_group.name, name = "hub1_fgt_public", address_prefixes = [cidrsubnet(module.module_azurerm_virtual_network["vnet_hub1"].virtual_network.address_space[0], 8, 0)], vnet_name = "vnet_hub1" }
    "hub1_fgt_private"  = { resource_group_name = module.module_azurerm_resource_group.resource_group.name, name = "hub1_fgt_private", address_prefixes = [cidrsubnet(module.module_azurerm_virtual_network["vnet_hub1"].virtual_network.address_space[0], 8, 1)], vnet_name = "vnet_hub1" }
    "hub1_fgt_ha"       = { resource_group_name = module.module_azurerm_resource_group.resource_group.name, name = "hub1_fgt_ha", address_prefixes = [cidrsubnet(module.module_azurerm_virtual_network["vnet_hub1"].virtual_network.address_space[0], 8, 3)], vnet_name = "vnet_hub1" }
    "hub1_fgt_mgmt"     = { resource_group_name = module.module_azurerm_resource_group.resource_group.name, name = "hub1_fgt_mgmt", address_prefixes = [cidrsubnet(module.module_azurerm_virtual_network["vnet_hub1"].virtual_network.address_space[0], 8, 4)], vnet_name = "vnet_hub1" }
    "RouteServerSubnet" = { resource_group_name = module.module_azurerm_resource_group.resource_group.name, name = "RouteServerSubnet", address_prefixes = [cidrsubnet(module.module_azurerm_virtual_network["vnet_hub1"].virtual_network.address_space[0], 8, 2)], vnet_name = "vnet_hub1" }
  }

  hub_virtual_network_peerings = {
    # Hub 1
    "hub1_to_spoke11" = { resource_group_name = module.module_azurerm_resource_group.resource_group.name, name = "hub1_to_spoke11", virtual_network_name = "vnet_hub1", remote_virtual_network_id = module.module_azurerm_virtual_network["vnet_spoke11"].virtual_network.id, allow_virtual_network_access = true, allow_forwarded_traffic = true, use_remote_gateways = null, allow_gateway_transit = true }
    "hub1_to_spoke12" = { resource_group_name = module.module_azurerm_resource_group.resource_group.name, name = "hub1_to_spoke12", virtual_network_name = "vnet_hub1", remote_virtual_network_id = module.module_azurerm_virtual_network["vnet_spoke12"].virtual_network.id, allow_virtual_network_access = true, allow_forwarded_traffic = true, use_remote_gateways = null, allow_gateway_transit = true }
  }

  hub_network_interfaces = {
    # Hub 1
    "nic_hub1_fortigate_1_1" = {
      resource_group_name           = module.module_azurerm_resource_group.resource_group.name
      name                          = "nic_hub1_fortigate_1_1"
      location                      = module.module_azurerm_virtual_network[module.module_azurerm_subnet["hub1_fgt_public"].subnet.virtual_network_name].virtual_network.location
      enable_ip_forwarding          = true
      enable_accelerated_networking = true

      ip_configurations = [
        {
          name                          = "ipconfig1"
          subnet_id                     = module.module_azurerm_subnet["hub1_fgt_public"].subnet.id
          private_ip_address_allocation = "Static"
          private_ip_address            = cidrhost(module.module_azurerm_subnet["hub1_fgt_public"].subnet.address_prefix, 4)
          public_ip_address_id          = null
        }
      ]
    }
    "nic_hub1_fortigate_1_2" = {
      resource_group_name           = module.module_azurerm_resource_group.resource_group.name
      name                          = "nic_hub1_fortigate_1_2"
      location                      = module.module_azurerm_virtual_network[module.module_azurerm_subnet["hub1_fgt_private"].subnet.virtual_network_name].virtual_network.location
      enable_ip_forwarding          = true
      enable_accelerated_networking = true

      ip_configurations = [
        {
          name                          = "ipconfig1"
          subnet_id                     = module.module_azurerm_subnet["hub1_fgt_private"].subnet.id
          private_ip_address_allocation = "Static"
          private_ip_address            = cidrhost(module.module_azurerm_subnet["hub1_fgt_private"].subnet.address_prefix, 4)
          public_ip_address_id          = null
        }
      ]
    }
    "nic_hub1_fortigate_1_3" = {
      resource_group_name           = module.module_azurerm_resource_group.resource_group.name
      name                          = "nic_hub1_fortigate_1_3"
      location                      = module.module_azurerm_virtual_network[module.module_azurerm_subnet["hub1_fgt_ha"].subnet.virtual_network_name].virtual_network.location
      enable_ip_forwarding          = true
      enable_accelerated_networking = true

      ip_configurations = [
        {
          name                          = "ipconfig1"
          subnet_id                     = module.module_azurerm_subnet["hub1_fgt_ha"].subnet.id
          private_ip_address_allocation = "Static"
          private_ip_address            = cidrhost(module.module_azurerm_subnet["hub1_fgt_ha"].subnet.address_prefix, 4)
          public_ip_address_id          = null
        }
      ]
    }
    "nic_hub1_fortigate_1_4" = {
      resource_group_name           = module.module_azurerm_resource_group.resource_group.name
      name                          = "nic_hub1_fortigate_1_4"
      location                      = module.module_azurerm_virtual_network[module.module_azurerm_subnet["hub1_fgt_mgmt"].subnet.virtual_network_name].virtual_network.location
      enable_ip_forwarding          = true
      enable_accelerated_networking = true

      ip_configurations = [
        {
          name                          = "ipconfig1"
          subnet_id                     = module.module_azurerm_subnet["hub1_fgt_mgmt"].subnet.id
          private_ip_address_allocation = "Static"
          private_ip_address            = cidrhost(module.module_azurerm_subnet["hub1_fgt_mgmt"].subnet.address_prefix, 4)
          public_ip_address_id          = null
        }
      ]
    }
    "nic_hub1_fortigate_2_1" = {
      resource_group_name           = module.module_azurerm_resource_group.resource_group.name
      name                          = "nic_hub1_fortigate_2_1"
      location                      = module.module_azurerm_virtual_network[module.module_azurerm_subnet["hub1_fgt_public"].subnet.virtual_network_name].virtual_network.location
      enable_ip_forwarding          = true
      enable_accelerated_networking = true

      ip_configurations = [
        {
          name                          = "ipconfig1"
          subnet_id                     = module.module_azurerm_subnet["hub1_fgt_public"].subnet.id
          private_ip_address_allocation = "Static"
          private_ip_address            = cidrhost(module.module_azurerm_subnet["hub1_fgt_public"].subnet.address_prefix, 5)
          public_ip_address_id          = null
        }
      ]
    }
    "nic_hub1_fortigate_2_2" = {
      resource_group_name           = module.module_azurerm_resource_group.resource_group.name
      name                          = "nic_hub1_fortigate_2_2"
      location                      = module.module_azurerm_virtual_network[module.module_azurerm_subnet["hub1_fgt_private"].subnet.virtual_network_name].virtual_network.location
      enable_ip_forwarding          = true
      enable_accelerated_networking = true

      ip_configurations = [
        {
          name                          = "ipconfig1"
          subnet_id                     = module.module_azurerm_subnet["hub1_fgt_private"].subnet.id
          private_ip_address_allocation = "Static"
          private_ip_address            = cidrhost(module.module_azurerm_subnet["hub1_fgt_private"].subnet.address_prefix, 5)
          public_ip_address_id          = null
        }
      ]
    }
    "nic_hub1_fortigate_2_3" = {
      resource_group_name           = module.module_azurerm_resource_group.resource_group.name
      name                          = "nic_hub1_fortigate_2_3"
      location                      = module.module_azurerm_virtual_network[module.module_azurerm_subnet["hub1_fgt_ha"].subnet.virtual_network_name].virtual_network.location
      enable_ip_forwarding          = true
      enable_accelerated_networking = true

      ip_configurations = [
        {
          name                          = "ipconfig1"
          subnet_id                     = module.module_azurerm_subnet["hub1_fgt_ha"].subnet.id
          private_ip_address_allocation = "Static"
          private_ip_address            = cidrhost(module.module_azurerm_subnet["hub1_fgt_ha"].subnet.address_prefix, 5)
          public_ip_address_id          = null
        }
      ]
    }
    "nic_hub1_fortigate_2_4" = {
      resource_group_name           = module.module_azurerm_resource_group.resource_group.name
      name                          = "nic_hub1_fortigate_2_4"
      location                      = module.module_azurerm_virtual_network[module.module_azurerm_subnet["hub1_fgt_mgmt"].subnet.virtual_network_name].virtual_network.location
      enable_ip_forwarding          = true
      enable_accelerated_networking = true

      ip_configurations = [
        {
          name                          = "ipconfig1"
          subnet_id                     = module.module_azurerm_subnet["hub1_fgt_mgmt"].subnet.id
          private_ip_address_allocation = "Static"
          private_ip_address            = cidrhost(module.module_azurerm_subnet["hub1_fgt_mgmt"].subnet.address_prefix, 5)
          public_ip_address_id          = null
        }
      ]
    }
  }

  hub_pblic_ips = {
    # Hub
    "pip_hub_elb_01" = { resource_group_name = module.module_azurerm_resource_group.resource_group.name, name = "pip_hub_elb_01", location = module.module_azurerm_virtual_network["vnet_hub1"].virtual_network.location, allocation_method = "Static", sku = "Standard" }
    # Azure Route Server
    "pip_${local.tag_project}_ars" = { resource_group_name = module.module_azurerm_resource_group.resource_group.name, name = "pip_${local.tag_project}_ars_pip", location = module.module_azurerm_resource_group.resource_group.location, allocation_method = "Static", sku = "Standard" }
  }

  hub_availability_sets = {
    "as_hub" = { resource_group_name = module.module_azurerm_resource_group.resource_group.name, location = module.module_azurerm_virtual_network["vnet_hub1"].virtual_network.location, name = "as_hub", platform_update_domain_count = "2", platform_fault_domain_count = "2", proximity_placement_group_id = null, managed = true }
  }

  hub_lbs = {
    "lb_hub1_ext_01" = {
      resource_group_name = module.module_azurerm_resource_group.resource_group.name
      location            = module.module_azurerm_virtual_network["vnet_hub1"].virtual_network.location
      name                = "lb_hub1_ext_01"
      sku                 = "standard"
      frontend_ip_configurations = [
        {
          name                 = "pip_hub_elb_01"
          public_ip_address_id = module.module_azurerm_public_ip["pip_hub_elb_01"].public_ip.id
        }
      ]
    }
  }

  hub_lb_backend_address_pools = {
    # Hub 1
    "lb_pool_01_hub1_ext_01" = { name = "lb_pool_01_hub1_ext_01", loadbalancer_id = module.module_azurerm_lb["lb_hub1_ext_01"].lb.id }
  }

  hub_lb_nat_rules = {
    # Hub 1
    "hub1_fgt1_https" = { name = "hub1_fgt1_https", loadbalancer_id = module.module_azurerm_lb["lb_hub1_ext_01"].lb.id, protocol = "Tcp", frontend_port = "1443", backend_port = "34443", frontend_ip_configuration_name = "pip_hub_elb_01" }
    "hub1_fgt2_https" = { name = "hub1_fgt2_https", loadbalancer_id = module.module_azurerm_lb["lb_hub1_ext_01"].lb.id, protocol = "Tcp", frontend_port = "2443", backend_port = "34443", frontend_ip_configuration_name = "pip_hub_elb_01" }
    "hub1_fgt1_ssh"   = { name = "hub1_fgt1_ssh", loadbalancer_id = module.module_azurerm_lb["lb_hub1_ext_01"].lb.id, protocol = "Tcp", frontend_port = "1422", backend_port = "3422", frontend_ip_configuration_name = "pip_hub_elb_01" }
    "hub1_fgt2_ssh"   = { name = "hub1_fgt2_ssh", loadbalancer_id = module.module_azurerm_lb["lb_hub1_ext_01"].lb.id, protocol = "Tcp", frontend_port = "2422", backend_port = "3422", frontend_ip_configuration_name = "pip_hub_elb_01" }
  }

  hub_lb_outbound_rules = {
    # Add Outbound rule
  }

  hub_lb_probes = {
    "lb_probe_hub1_ext_lb_01" = { resource_group_name = module.module_azurerm_resource_group.resource_group.name, name = "lb_probe_hub1_ext_lb_01", loadbalancer_id = module.module_azurerm_lb["lb_hub1_ext_01"].lb.id, port = "8008" }
  }

  hub_lb_rules = {
    # Add LB rule
  }

  hub_network_interface_backend_address_pool_associations = {
    # Add Network Interface backend address pool associations
  }

  hub_network_interface_nat_rule_associations = {
    "hub1_fgt1_https" = { network_interface_id = module.module_azurerm_network_interface["nic_hub1_fortigate_1_4"].network_interface.id, ip_configuration_name = "ipconfig1", nat_rule_id = module.module_azurerm_lb_nat_rule["hub1_fgt1_https"].lb_nat_rule.id }
    "hub1_fgt2_https" = { network_interface_id = module.module_azurerm_network_interface["nic_hub1_fortigate_2_4"].network_interface.id, ip_configuration_name = "ipconfig1", nat_rule_id = module.module_azurerm_lb_nat_rule["hub1_fgt2_https"].lb_nat_rule.id }
    "hub1_fgt1_ssh"   = { network_interface_id = module.module_azurerm_network_interface["nic_hub1_fortigate_1_4"].network_interface.id, ip_configuration_name = "ipconfig1", nat_rule_id = module.module_azurerm_lb_nat_rule["hub1_fgt1_ssh"].lb_nat_rule.id }
    "hub1_fgt2_ssh"   = { network_interface_id = module.module_azurerm_network_interface["nic_hub1_fortigate_2_4"].network_interface.id, ip_configuration_name = "ipconfig1", nat_rule_id = module.module_azurerm_lb_nat_rule["hub1_fgt2_ssh"].lb_nat_rule.id }
  }

  hub_network_security_groups = {
    "nsg_pub"  = { resource_group_name = module.module_azurerm_resource_group.resource_group.name, name = "nsg_pub", vnet_name = module.module_azurerm_virtual_network["vnet_hub1"].virtual_network.location }
    "nsg_priv" = { resource_group_name = module.module_azurerm_resource_group.resource_group.name, name = "nsg_priv", vnet_name = module.module_azurerm_virtual_network["vnet_hub1"].virtual_network.location }
  }

  hub_network_security_rules = {
    "hub1_pub_all_inbound"   = { resource_group_name = module.module_azurerm_resource_group.resource_group.name, name = "hub1_pub_all_inbound", network_security_group_name = module.module_azurerm_network_security_group["nsg_pub"].network_security_group.name, priority = "100", direction = "Inbound", access = "Allow", protocol = "*" }
    "hub1_pub_all_outbound"  = { resource_group_name = module.module_azurerm_resource_group.resource_group.name, name = "hub1_pub_all_outbound", network_security_group_name = module.module_azurerm_network_security_group["nsg_pub"].network_security_group.name, priority = "100", direction = "Outbound", access = "Allow", protocol = "*" }
    "hub1_priv_all_inbound"  = { resource_group_name = module.module_azurerm_resource_group.resource_group.name, name = "hub1_priv_all_inbound", network_security_group_name = module.module_azurerm_network_security_group["nsg_priv"].network_security_group.name, priority = "100", direction = "Inbound", access = "Allow", protocol = "*" }
    "hub1_priv_all_outbound" = { resource_group_name = module.module_azurerm_resource_group.resource_group.name, name = "hub1_priv_all_outbound", network_security_group_name = module.module_azurerm_network_security_group["nsg_priv"].network_security_group.name, priority = "100", direction = "Outbound", access = "Allow", protocol = "*" }
  }

  hub_network_interface_security_group_associations = {
    # "nic_hub1_fortigate_1_1" = { network_interface_id = module.module_azurerm_network_interface["nic_hub1_fortigate_1_1"].network_interface.id, network_security_group_id = module.module_azurerm_network_security_group["nsg_pub"].network_security_group.id }
    # "nic_hub1_fortigate_1_2" = { network_interface_id = module.module_azurerm_network_interface["nic_hub1_fortigate_1_2"].network_interface.id, network_security_group_id = module.module_azurerm_network_security_group["nsg_priv"].network_security_group.id }
    # "nic_hub1_fortigate_1_3" = { network_interface_id = module.module_azurerm_network_interface["nic_hub1_fortigate_1_3"].network_interface.id, network_security_group_id = module.module_azurerm_network_security_group["nsg_priv"].network_security_group.id }
    # "nic_hub1_fortigate_1_4" = { network_interface_id = module.module_azurerm_network_interface["nic_hub1_fortigate_1_4"].network_interface.id, network_security_group_id = module.module_azurerm_network_security_group["nsg_pub"].network_security_group.id }

    # "nic_hub1_fortigate_2_1" = { network_interface_id = module.module_azurerm_network_interface["nic_hub1_fortigate_2_1"].network_interface.id, network_security_group_id = module.module_azurerm_network_security_group["nsg_pub"].network_security_group.id }
    # "nic_hub1_fortigate_2_2" = { network_interface_id = module.module_azurerm_network_interface["nic_hub1_fortigate_2_2"].network_interface.id, network_security_group_id = module.module_azurerm_network_security_group["nsg_priv"].network_security_group.id }
    # "nic_hub1_fortigate_2_3" = { network_interface_id = module.module_azurerm_network_interface["nic_hub1_fortigate_2_3"].network_interface.id, network_security_group_id = module.module_azurerm_network_security_group["nsg_priv"].network_security_group.id }
    # "nic_hub1_fortigate_2_4" = { network_interface_id = module.module_azurerm_network_interface["nic_hub1_fortigate_2_4"].network_interface.id, network_security_group_id = module.module_azurerm_network_security_group["nsg_pub"].network_security_group.id }
  }

  hub_subnet_network_security_group_associations = {
    "hub1_fgt_public"  = { subnet_id = module.module_azurerm_subnet["hub1_fgt_public"].subnet.id, network_security_group_id = module.module_azurerm_network_security_group["nsg_pub"].network_security_group.id }
    "hub1_fgt_private" = { subnet_id = module.module_azurerm_subnet["hub1_fgt_private"].subnet.id, network_security_group_id = module.module_azurerm_network_security_group["nsg_priv"].network_security_group.id }
    "hub1_fgt_ha"      = { subnet_id = module.module_azurerm_subnet["hub1_fgt_ha"].subnet.id, network_security_group_id = module.module_azurerm_network_security_group["nsg_priv"].network_security_group.id }
    "hub1_fgt_mgmt"    = { subnet_id = module.module_azurerm_subnet["hub1_fgt_mgmt"].subnet.id, network_security_group_id = module.module_azurerm_network_security_group["nsg_pub"].network_security_group.id }
  }

  hub_storage_accounts = {
    "sthub1" = {
      resource_group_name      = module.module_azurerm_resource_group.resource_group.name
      location                 = module.module_azurerm_virtual_network["vnet_hub1"].virtual_network.location
      name                     = format("%s%s", "sthub1", "${random_id.random_id.hex}")
      account_replication_type = "LRS"
      account_tier             = "Standard"
    }
  }

  hub_route_tables = {
    "rt_hub1_fgt_public"  = { resource_group_name = module.module_azurerm_resource_group.resource_group.name, name = "rt_hub1_fgt_public", vnet_name = module.module_azurerm_virtual_network["vnet_hub1"].virtual_network.location, disable_bgp_route_propagation = "false" }
    "rt_hub1_fgt_private" = { resource_group_name = module.module_azurerm_resource_group.resource_group.name, name = "rt_hub1_fgt_private", vnet_name = module.module_azurerm_virtual_network["vnet_hub1"].virtual_network.location, disable_bgp_route_propagation = "true" }
    "rt_hub1_fgt_ha"      = { resource_group_name = module.module_azurerm_resource_group.resource_group.name, name = "rt_hub1_fgt_ha", vnet_name = module.module_azurerm_virtual_network["vnet_hub1"].virtual_network.location, disable_bgp_route_propagation = "true" }
    "rt_hub1_fgt_mgmt"    = { resource_group_name = module.module_azurerm_resource_group.resource_group.name, name = "rt_hub1_fgt_mgmt", vnet_name = module.module_azurerm_virtual_network["vnet_hub1"].virtual_network.location, disable_bgp_route_propagation = "false" }
  }

  hub_subnet_route_table_associations = {
    "hub1_fgt_public"  = { subnet_id = module.module_azurerm_subnet["hub1_fgt_public"].subnet.id, route_table_id = module.module_azurerm_route_table["rt_hub1_fgt_public"].route_table.id }
    "hub1_fgt_private" = { subnet_id = module.module_azurerm_subnet["hub1_fgt_private"].subnet.id, route_table_id = module.module_azurerm_route_table["rt_hub1_fgt_private"].route_table.id }
    "hub1_fgt_ha"      = { subnet_id = module.module_azurerm_subnet["hub1_fgt_ha"].subnet.id, route_table_id = module.module_azurerm_route_table["rt_hub1_fgt_ha"].route_table.id }
    "hub1_fgt_mgmt"    = { subnet_id = module.module_azurerm_subnet["hub1_fgt_mgmt"].subnet.id, route_table_id = module.module_azurerm_route_table["rt_hub1_fgt_mgmt"].route_table.id }
  }

  hub_linux_virtual_machines = {
    # Add Linux virtual machines
  }

  vm_image = {
    "fortinet" = {
      publisher = "fortinet"
      offer     = "fortinet_fortigate-vm_v5"
      sku       = "fortinet_fg-vm_payg_20190624"
      version   = "7.0.5"
    }
  }

  hub_virtual_machines = {
    "vm_hub_fgt_1" = {
      resource_group_name = module.module_azurerm_resource_group.resource_group.name
      location            = module.module_azurerm_virtual_network["vnet_hub1"].virtual_network.location

      name              = "vm-hub-fgt-1"
      identity_identity = "SystemAssigned"

      availability_set_id = module.module_azurerm_availability_set["as_hub"].availability_set.id
      zones               = null

      delete_os_disk_on_termination    = true
      delete_data_disks_on_termination = true

      network_interface_ids        = [for nic in ["nic_hub1_fortigate_1_1", "nic_hub1_fortigate_1_2", "nic_hub1_fortigate_1_3", "nic_hub1_fortigate_1_4"] : module.module_azurerm_network_interface[nic].network_interface.id]
      primary_network_interface_id = module.module_azurerm_network_interface["nic_hub1_fortigate_1_1"].network_interface.id

      vm_size = "Standard_F8s"

      storage_image_reference_publisher = local.vm_image["fortinet"].publisher
      storage_image_reference_offer     = local.vm_image["fortinet"].offer
      storage_image_reference_sku       = local.vm_image["fortinet"].sku
      storage_image_reference_version   = local.vm_image["fortinet"].version

      plan_publisher = local.vm_image["fortinet"].publisher
      plan_product   = local.vm_image["fortinet"].offer
      plan_name      = local.vm_image["fortinet"].sku

      os_profile_admin_username = var.username
      os_profile_admin_password = var.password

      os_profile_linux_config_disable_password_authentication = false

      boot_diagnostics_enabled     = true
      boot_diagnostics_storage_uri = module.module_azurerm_storage_account["sthub1"].storage_account.primary_blob_endpoint

      storage_os_disk_name              = "disk_os_hub_fgt_1"
      storage_os_disk_caching           = "ReadWrite"
      storage_os_disk_managed_disk_type = "Premium_LRS"
      storage_os_disk_create_option     = "FromImage"

      storage_data_disks = [
        {
          name              = "disk_data_hub_fgt_1"
          managed_disk_type = "Premium_LRS"
          create_option     = "Empty"
          disk_size_gb      = "30"
          lun               = "0"
        }
      ]

      tags = {
        Project = local.project
      }

      # FortiGate Configuration
      config_data = templatefile("./assets/fgt-hub-userdata.tpl", {
        fgt_id               = "vm-hub-fgt-1"
        role                 = ""
        sync-port            = ""
        psk                  = ""
        masterip             = ""
        fgt_license_file     = ""
        fgt_username         = var.username
        fgt_config_ha        = true
        fgt_config_autoscale = false
        fgt_ssh_public_key   = ""
        fgt_config_probe     = true
        gui_theme            = "jade"
        Port1IP              = module.module_azurerm_network_interface["nic_hub1_fortigate_1_1"].network_interface.private_ip_address
        Port1Alias           = "pub"
        Port2IP              = module.module_azurerm_network_interface["nic_hub1_fortigate_1_2"].network_interface.private_ip_address
        Port2Alias           = "priv"
        Port3IP              = module.module_azurerm_network_interface["nic_hub1_fortigate_1_3"].network_interface.private_ip_address
        Port3Alias           = "ha"
        Port4IP              = module.module_azurerm_network_interface["nic_hub1_fortigate_1_4"].network_interface.private_ip_address
        Port4Alias           = "mgmt"

        port3subnetmask = cidrnetmask(module.module_azurerm_subnet["hub1_fgt_ha"].subnet.address_prefix)
        port4subnetmask = cidrnetmask(module.module_azurerm_subnet["hub1_fgt_mgmt"].subnet.address_prefix)

        fgt_external_gw = cidrhost(module.module_azurerm_subnet["hub1_fgt_public"].subnet.address_prefix, 1)
        fgt_internal_gw = cidrhost(module.module_azurerm_subnet["hub1_fgt_private"].subnet.address_prefix, 1)
        fgt_mgmt_gw     = cidrhost(module.module_azurerm_subnet["hub1_fgt_mgmt"].subnet.address_prefix, 1)

        fgt_ha_peerip   = module.module_azurerm_network_interface["nic_hub1_fortigate_2_3"].network_interface.private_ip_address
        fgt_ha_priority = "100"
        vnet_network    = module.module_azurerm_virtual_network["vnet_hub1"].virtual_network.address_space[0]

        port_ha   = "port3"
        port_mgmt = "port4"

        fgt_config_bgp = true
        fgt_as         = "64622"
        peer1          = cidrhost(module.module_azurerm_subnet["RouteServerSubnet"].subnet.address_prefix, 4)
        peer2          = cidrhost(module.module_azurerm_subnet["RouteServerSubnet"].subnet.address_prefix, 5)
        peer_as        = "65515"

        fgt_config_sdwan = true
        }
      )
    }
    "vm_hub_fgt_2" = {
      resource_group_name = module.module_azurerm_resource_group.resource_group.name
      location            = module.module_azurerm_virtual_network["vnet_hub1"].virtual_network.location

      name              = "vm-hub-fgt-2"
      identity_identity = "SystemAssigned"

      availability_set_id = module.module_azurerm_availability_set["as_hub"].availability_set.id
      zones               = null

      delete_os_disk_on_termination    = true
      delete_data_disks_on_termination = true

      network_interface_ids        = [for nic in ["nic_hub1_fortigate_2_1", "nic_hub1_fortigate_2_2", "nic_hub1_fortigate_2_3", "nic_hub1_fortigate_2_4"] : module.module_azurerm_network_interface[nic].network_interface.id]
      primary_network_interface_id = module.module_azurerm_network_interface["nic_hub1_fortigate_2_1"].network_interface.id

      vm_size = "Standard_F8s"

      storage_image_reference_publisher = local.vm_image["fortinet"].publisher
      storage_image_reference_offer     = local.vm_image["fortinet"].offer
      storage_image_reference_sku       = local.vm_image["fortinet"].sku
      storage_image_reference_version   = local.vm_image["fortinet"].version

      plan_publisher = local.vm_image["fortinet"].publisher
      plan_product   = local.vm_image["fortinet"].offer
      plan_name      = local.vm_image["fortinet"].sku

      os_profile_admin_username = var.username
      os_profile_admin_password = var.password

      os_profile_linux_config_disable_password_authentication = false

      boot_diagnostics_enabled     = true
      boot_diagnostics_storage_uri = module.module_azurerm_storage_account["sthub1"].storage_account.primary_blob_endpoint

      storage_os_disk_name              = "disk_os_hub_fgt_2"
      storage_os_disk_caching           = "ReadWrite"
      storage_os_disk_managed_disk_type = "Premium_LRS"
      storage_os_disk_create_option     = "FromImage"

      storage_data_disks = [
        {
          name              = "disk_data_hub_fgt_2"
          managed_disk_type = "Premium_LRS"
          create_option     = "Empty"
          disk_size_gb      = "30"
          lun               = "0"
        }
      ]

      tags = {
        Project = local.project
      }

      # FortiGate Configuration
      config_data = templatefile("./assets/fgt-hub-userdata.tpl", {
        fgt_id               = "vm-hub-fgt-2",
        role                 = ""
        sync-port            = ""
        psk                  = ""
        masterip             = ""
        fgt_license_file     = "",
        fgt_username         = var.username,
        fgt_config_ha        = true,
        fgt_config_autoscale = false,
        fgt_ssh_public_key   = "",
        fgt_config_probe     = true,
        gui_theme            = "jade",
        Port1IP              = module.module_azurerm_network_interface["nic_hub1_fortigate_2_1"].network_interface.private_ip_address,
        Port1Alias           = "pub",
        Port2IP              = module.module_azurerm_network_interface["nic_hub1_fortigate_2_2"].network_interface.private_ip_address,
        Port2Alias           = "priv",
        Port3IP              = module.module_azurerm_network_interface["nic_hub1_fortigate_2_3"].network_interface.private_ip_address,
        Port3Alias           = "ha",
        Port4IP              = module.module_azurerm_network_interface["nic_hub1_fortigate_2_4"].network_interface.private_ip_address,
        Port4Alias           = "mgmt",

        port3subnetmask = cidrnetmask(module.module_azurerm_subnet["hub1_fgt_ha"].subnet.address_prefix),
        port4subnetmask = cidrnetmask(module.module_azurerm_subnet["hub1_fgt_mgmt"].subnet.address_prefix),

        fgt_external_gw = cidrhost(module.module_azurerm_subnet["hub1_fgt_public"].subnet.address_prefix, 1),
        fgt_internal_gw = cidrhost(module.module_azurerm_subnet["hub1_fgt_private"].subnet.address_prefix, 1),
        fgt_mgmt_gw     = cidrhost(module.module_azurerm_subnet["hub1_fgt_mgmt"].subnet.address_prefix, 1),

        fgt_ha_peerip   = module.module_azurerm_network_interface["nic_hub1_fortigate_1_3"].network_interface.private_ip_address,
        fgt_ha_priority = "50",
        vnet_network    = module.module_azurerm_virtual_network["vnet_hub1"].virtual_network.address_space[0],

        port_ha   = "port3",
        port_mgmt = "port4",

        fgt_config_bgp = true,
        fgt_as         = "64622",
        peer1          = cidrhost(module.module_azurerm_subnet["RouteServerSubnet"].subnet.address_prefix, 4),
        peer2          = cidrhost(module.module_azurerm_subnet["RouteServerSubnet"].subnet.address_prefix, 5),
        peer_as        = "65515",

        fgt_config_sdwan = true
        }
      )
    }
  }

  hub_role_assignments = {
    "vm_hub_fgt_1" = { scope = module.module_azurerm_resource_group.resource_group.id, role_definition_name = "Reader", principal_id = module.module_azurerm_virtual_machine["vm_hub_fgt_1"].virtual_machine.identity[0].principal_id }
    "vm_hub_fgt_2" = { scope = module.module_azurerm_resource_group.resource_group.id, role_definition_name = "Reader", principal_id = module.module_azurerm_virtual_machine["vm_hub_fgt_2"].virtual_machine.identity[0].principal_id }
  }
}