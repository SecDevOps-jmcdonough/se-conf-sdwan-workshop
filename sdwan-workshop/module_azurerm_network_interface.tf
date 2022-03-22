locals {
  network_interfaces = {
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
    # Branch 1
    "nic_br1_fortigate_1_1" = {
      resource_group_name           = module.module_azurerm_resource_group.resource_group.name
      name                          = "nic_br1_fortigate_1_1"
      location                      = module.module_azurerm_virtual_network[module.module_azurerm_subnet["br1_fgt_pub1"].subnet.virtual_network_name].virtual_network.location
      enable_ip_forwarding          = true
      enable_accelerated_networking = true

      ip_configurations = [
        {
          name                          = "ipconfig1"
          subnet_id                     = module.module_azurerm_subnet["br1_fgt_pub1"].subnet.id
          private_ip_address_allocation = "Static"
          private_ip_address            = cidrhost(module.module_azurerm_subnet["br1_fgt_pub1"].subnet.address_prefix, 4)
          public_ip_address_id          = null
        }
      ]
    }
    "nic_br1_fortigate_1_2" = {
      resource_group_name           = module.module_azurerm_resource_group.resource_group.name
      name                          = "nic_br1_fortigate_1_2"
      location                      = module.module_azurerm_virtual_network[module.module_azurerm_subnet["br1_fgt_priv"].subnet.virtual_network_name].virtual_network.location
      enable_ip_forwarding          = true
      enable_accelerated_networking = true

      ip_configurations = [
        {
          name                          = "ipconfig1"
          subnet_id                     = module.module_azurerm_subnet["br1_fgt_priv"].subnet.id
          private_ip_address_allocation = "Static"
          private_ip_address            = cidrhost(module.module_azurerm_subnet["br1_fgt_priv"].subnet.address_prefix, 4)
          public_ip_address_id          = null
        }
      ]
    }
    "nic_br1_fortigate_1_3" = {
      resource_group_name           = module.module_azurerm_resource_group.resource_group.name
      name                          = "nic_br1_fortigate_1_3"
      location                      = module.module_azurerm_virtual_network[module.module_azurerm_subnet["br1_fgt_pub2"].subnet.virtual_network_name].virtual_network.location
      enable_ip_forwarding          = true
      enable_accelerated_networking = true

      ip_configurations = [
        {
          name                          = "ipconfig1"
          subnet_id                     = module.module_azurerm_subnet["br1_fgt_pub2"].subnet.id
          private_ip_address_allocation = "Static"
          private_ip_address            = cidrhost(module.module_azurerm_subnet["br1_fgt_pub2"].subnet.address_prefix, 14)
          public_ip_address_id          = null
        }
      ]
    }
    "nic_br1_fortigate_1_4" = {
      resource_group_name           = module.module_azurerm_resource_group.resource_group.name
      name                          = "nic_br1_fortigate_1_4"
      location                      = module.module_azurerm_virtual_network[module.module_azurerm_subnet["br1_fgt_ha"].subnet.virtual_network_name].virtual_network.location
      enable_ip_forwarding          = true
      enable_accelerated_networking = true

      ip_configurations = [
        {
          name                          = "ipconfig1"
          subnet_id                     = module.module_azurerm_subnet["br1_fgt_ha"].subnet.id
          private_ip_address_allocation = "Static"
          private_ip_address            = cidrhost(module.module_azurerm_subnet["br1_fgt_ha"].subnet.address_prefix, 4)
          public_ip_address_id          = null
        }
      ]
    }
    "nic_br1_fortigate_1_5" = {
      resource_group_name           = module.module_azurerm_resource_group.resource_group.name
      name                          = "nic_br1_fortigate_1_5"
      location                      = module.module_azurerm_virtual_network[module.module_azurerm_subnet["br1_fgt_mgmt"].subnet.virtual_network_name].virtual_network.location
      enable_ip_forwarding          = true
      enable_accelerated_networking = true

      ip_configurations = [
        {
          name                          = "ipconfig1"
          subnet_id                     = module.module_azurerm_subnet["br1_fgt_mgmt"].subnet.id
          private_ip_address_allocation = "Static"
          private_ip_address            = cidrhost(module.module_azurerm_subnet["br1_fgt_mgmt"].subnet.address_prefix, 4)
          public_ip_address_id          = null
        }
      ]
    }
    "nic_br1_fortigate_2_1" = {
      resource_group_name           = module.module_azurerm_resource_group.resource_group.name
      name                          = "nic_br1_fortigate_2_1"
      location                      = module.module_azurerm_virtual_network[module.module_azurerm_subnet["br1_fgt_pub1"].subnet.virtual_network_name].virtual_network.location
      enable_ip_forwarding          = true
      enable_accelerated_networking = true

      ip_configurations = [
        {
          name                          = "ipconfig1"
          subnet_id                     = module.module_azurerm_subnet["br1_fgt_pub1"].subnet.id
          private_ip_address_allocation = "Static"
          private_ip_address            = cidrhost(module.module_azurerm_subnet["br1_fgt_pub1"].subnet.address_prefix, 5)
          public_ip_address_id          = null
        }
      ]
    }
    "nic_br1_fortigate_2_2" = {
      resource_group_name           = module.module_azurerm_resource_group.resource_group.name
      name                          = "nic_br1_fortigate_2_2"
      location                      = module.module_azurerm_virtual_network[module.module_azurerm_subnet["br1_fgt_priv"].subnet.virtual_network_name].virtual_network.location
      enable_ip_forwarding          = true
      enable_accelerated_networking = true

      ip_configurations = [
        {
          name                          = "ipconfig1"
          subnet_id                     = module.module_azurerm_subnet["br1_fgt_priv"].subnet.id
          private_ip_address_allocation = "Static"
          private_ip_address            = cidrhost(module.module_azurerm_subnet["br1_fgt_priv"].subnet.address_prefix, 5)
          public_ip_address_id          = null
        }
      ]
    }
    "nic_br1_fortigate_2_3" = {
      resource_group_name           = module.module_azurerm_resource_group.resource_group.name
      name                          = "nic_br1_fortigate_2_3"
      location                      = module.module_azurerm_virtual_network[module.module_azurerm_subnet["br1_fgt_pub2"].subnet.virtual_network_name].virtual_network.location
      enable_ip_forwarding          = true
      enable_accelerated_networking = true

      ip_configurations = [
        {
          name                          = "ipconfig1"
          subnet_id                     = module.module_azurerm_subnet["br1_fgt_pub2"].subnet.id
          private_ip_address_allocation = "Static"
          private_ip_address            = cidrhost(module.module_azurerm_subnet["br1_fgt_pub2"].subnet.address_prefix, 15)
          public_ip_address_id          = null
        }
      ]
    }
    "nic_br1_fortigate_2_4" = {
      resource_group_name           = module.module_azurerm_resource_group.resource_group.name
      name                          = "nic_br1_fortigate_2_4"
      location                      = module.module_azurerm_virtual_network[module.module_azurerm_subnet["br1_fgt_ha"].subnet.virtual_network_name].virtual_network.location
      enable_ip_forwarding          = true
      enable_accelerated_networking = true

      ip_configurations = [
        {
          name                          = "ipconfig1"
          subnet_id                     = module.module_azurerm_subnet["br1_fgt_ha"].subnet.id
          private_ip_address_allocation = "Static"
          private_ip_address            = cidrhost(module.module_azurerm_subnet["br1_fgt_ha"].subnet.address_prefix, 5)
          public_ip_address_id          = null
        }
      ]
    }
    "nic_br1_fortigate_2_5" = {
      resource_group_name           = module.module_azurerm_resource_group.resource_group.name
      name                          = "nic_br1_fortigate_2_5"
      location                      = module.module_azurerm_virtual_network[module.module_azurerm_subnet["br1_fgt_mgmt"].subnet.virtual_network_name].virtual_network.location
      enable_ip_forwarding          = true
      enable_accelerated_networking = true

      ip_configurations = [
        {
          name                          = "ipconfig1"
          subnet_id                     = module.module_azurerm_subnet["br1_fgt_mgmt"].subnet.id
          private_ip_address_allocation = "Static"
          private_ip_address            = cidrhost(module.module_azurerm_subnet["br1_fgt_mgmt"].subnet.address_prefix, 5)
          public_ip_address_id          = null
        }
      ]
    }
    # Branch 2
    "nic_br2_fortigate_1_1" = {
      resource_group_name           = module.module_azurerm_resource_group.resource_group.name
      name                          = "nic_br2_fortigate_1_1"
      location                      = module.module_azurerm_virtual_network[module.module_azurerm_subnet["br2_fgt_pub1"].subnet.virtual_network_name].virtual_network.location
      enable_ip_forwarding          = true
      enable_accelerated_networking = true

      ip_configurations = [
        {
          name                          = "ipconfig1"
          subnet_id                     = module.module_azurerm_subnet["br2_fgt_pub1"].subnet.id
          private_ip_address_allocation = "Static"
          private_ip_address            = cidrhost(module.module_azurerm_subnet["br2_fgt_pub1"].subnet.address_prefix, 4)
          public_ip_address_id          = null
        }
      ]
    }
    "nic_br2_fortigate_1_2" = {
      resource_group_name           = module.module_azurerm_resource_group.resource_group.name
      name                          = "nic_br2_fortigate_1_2"
      location                      = module.module_azurerm_virtual_network[module.module_azurerm_subnet["br2_fgt_priv"].subnet.virtual_network_name].virtual_network.location
      enable_ip_forwarding          = true
      enable_accelerated_networking = true

      ip_configurations = [
        {
          name                          = "ipconfig1"
          subnet_id                     = module.module_azurerm_subnet["br2_fgt_priv"].subnet.id
          private_ip_address_allocation = "Static"
          private_ip_address            = cidrhost(module.module_azurerm_subnet["br2_fgt_priv"].subnet.address_prefix, 4)
          public_ip_address_id          = null
        }
      ]
    }
    "nic_br2_fortigate_1_3" = {
      resource_group_name           = module.module_azurerm_resource_group.resource_group.name
      name                          = "nic_br2_fortigate_1_3"
      location                      = module.module_azurerm_virtual_network[module.module_azurerm_subnet["br2_fgt_pub2"].subnet.virtual_network_name].virtual_network.location
      enable_ip_forwarding          = true
      enable_accelerated_networking = true

      ip_configurations = [
        {
          name                          = "ipconfig1"
          subnet_id                     = module.module_azurerm_subnet["br2_fgt_pub2"].subnet.id
          private_ip_address_allocation = "Static"
          private_ip_address            = cidrhost(module.module_azurerm_subnet["br2_fgt_pub2"].subnet.address_prefix, 14)
          public_ip_address_id          = null
        }
      ]
    }
    "nic_br2_fortigate_1_4" = {
      resource_group_name           = module.module_azurerm_resource_group.resource_group.name
      name                          = "nic_br2_fortigate_1_4"
      location                      = module.module_azurerm_virtual_network[module.module_azurerm_subnet["br2_fgt_ha"].subnet.virtual_network_name].virtual_network.location
      enable_ip_forwarding          = true
      enable_accelerated_networking = true

      ip_configurations = [
        {
          name                          = "ipconfig1"
          subnet_id                     = module.module_azurerm_subnet["br2_fgt_ha"].subnet.id
          private_ip_address_allocation = "Static"
          private_ip_address            = cidrhost(module.module_azurerm_subnet["br2_fgt_ha"].subnet.address_prefix, 4)
          public_ip_address_id          = null
        }
      ]
    }
    "nic_br2_fortigate_1_5" = {
      resource_group_name           = module.module_azurerm_resource_group.resource_group.name
      name                          = "nic_br2_fortigate_1_5"
      location                      = module.module_azurerm_virtual_network[module.module_azurerm_subnet["br2_fgt_mgmt"].subnet.virtual_network_name].virtual_network.location
      enable_ip_forwarding          = true
      enable_accelerated_networking = true

      ip_configurations = [
        {
          name                          = "ipconfig1"
          subnet_id                     = module.module_azurerm_subnet["br2_fgt_mgmt"].subnet.id
          private_ip_address_allocation = "Static"
          private_ip_address            = cidrhost(module.module_azurerm_subnet["br2_fgt_mgmt"].subnet.address_prefix, 4)
          public_ip_address_id          = null
        }
      ]
    }
    "nic_br2_fortigate_2_1" = {
      resource_group_name           = module.module_azurerm_resource_group.resource_group.name
      name                          = "nic_br2_fortigate_2_1"
      location                      = module.module_azurerm_virtual_network[module.module_azurerm_subnet["br2_fgt_pub1"].subnet.virtual_network_name].virtual_network.location
      enable_ip_forwarding          = true
      enable_accelerated_networking = true

      ip_configurations = [
        {
          name                          = "ipconfig1"
          subnet_id                     = module.module_azurerm_subnet["br2_fgt_pub1"].subnet.id
          private_ip_address_allocation = "Static"
          private_ip_address            = cidrhost(module.module_azurerm_subnet["br2_fgt_pub1"].subnet.address_prefix, 5)
          public_ip_address_id          = null
        }
      ]
    }
    "nic_br2_fortigate_2_2" = {
      resource_group_name           = module.module_azurerm_resource_group.resource_group.name
      name                          = "nic_br2_fortigate_2_2"
      location                      = module.module_azurerm_virtual_network[module.module_azurerm_subnet["br2_fgt_priv"].subnet.virtual_network_name].virtual_network.location
      enable_ip_forwarding          = true
      enable_accelerated_networking = true

      ip_configurations = [
        {
          name                          = "ipconfig1"
          subnet_id                     = module.module_azurerm_subnet["br2_fgt_priv"].subnet.id
          private_ip_address_allocation = "Static"
          private_ip_address            = cidrhost(module.module_azurerm_subnet["br2_fgt_priv"].subnet.address_prefix, 5)
          public_ip_address_id          = null
        }
      ]
    }
    "nic_br2_fortigate_2_3" = {
      resource_group_name           = module.module_azurerm_resource_group.resource_group.name
      name                          = "nic_br2_fortigate_2_3"
      location                      = module.module_azurerm_virtual_network[module.module_azurerm_subnet["br2_fgt_pub2"].subnet.virtual_network_name].virtual_network.location
      enable_ip_forwarding          = true
      enable_accelerated_networking = true

      ip_configurations = [
        {
          name                          = "ipconfig1"
          subnet_id                     = module.module_azurerm_subnet["br2_fgt_pub2"].subnet.id
          private_ip_address_allocation = "Static"
          private_ip_address            = cidrhost(module.module_azurerm_subnet["br2_fgt_pub2"].subnet.address_prefix, 15)
          public_ip_address_id          = null
        }
      ]
    }
    "nic_br2_fortigate_2_4" = {
      resource_group_name           = module.module_azurerm_resource_group.resource_group.name
      name                          = "nic_br2_fortigate_2_4"
      location                      = module.module_azurerm_virtual_network[module.module_azurerm_subnet["br2_fgt_ha"].subnet.virtual_network_name].virtual_network.location
      enable_ip_forwarding          = true
      enable_accelerated_networking = true

      ip_configurations = [
        {
          name                          = "ipconfig1"
          subnet_id                     = module.module_azurerm_subnet["br2_fgt_ha"].subnet.id
          private_ip_address_allocation = "Static"
          private_ip_address            = cidrhost(module.module_azurerm_subnet["br2_fgt_ha"].subnet.address_prefix, 5)
          public_ip_address_id          = null
        }
      ]
    }
    "nic_br2_fortigate_2_5" = {
      resource_group_name           = module.module_azurerm_resource_group.resource_group.name
      name                          = "nic_br2_fortigate_2_5"
      location                      = module.module_azurerm_virtual_network[module.module_azurerm_subnet["br2_fgt_mgmt"].subnet.virtual_network_name].virtual_network.location
      enable_ip_forwarding          = true
      enable_accelerated_networking = true

      ip_configurations = [
        {
          name                          = "ipconfig1"
          subnet_id                     = module.module_azurerm_subnet["br2_fgt_mgmt"].subnet.id
          private_ip_address_allocation = "Static"
          private_ip_address            = cidrhost(module.module_azurerm_subnet["br2_fgt_mgmt"].subnet.address_prefix, 5)
          public_ip_address_id          = null
        }
      ]
    }
    # Branch 3
    "nic_br3_fortigate_1_1" = {
      resource_group_name           = module.module_azurerm_resource_group.resource_group.name
      name                          = "nic_br3_fortigate_1_1"
      location                      = module.module_azurerm_virtual_network[module.module_azurerm_subnet["br3_fgt_pub1"].subnet.virtual_network_name].virtual_network.location
      enable_ip_forwarding          = true
      enable_accelerated_networking = true

      ip_configurations = [
        {
          name                          = "ipconfig1"
          subnet_id                     = module.module_azurerm_subnet["br3_fgt_pub1"].subnet.id
          private_ip_address_allocation = "Static"
          private_ip_address            = cidrhost(module.module_azurerm_subnet["br3_fgt_pub1"].subnet.address_prefix, 4)
          public_ip_address_id          = null
        }
      ]
    }
    "nic_br3_fortigate_1_2" = {
      resource_group_name           = module.module_azurerm_resource_group.resource_group.name
      name                          = "nic_br3_fortigate_1_2"
      location                      = module.module_azurerm_virtual_network[module.module_azurerm_subnet["br3_fgt_priv"].subnet.virtual_network_name].virtual_network.location
      enable_ip_forwarding          = true
      enable_accelerated_networking = true

      ip_configurations = [
        {
          name                          = "ipconfig1"
          subnet_id                     = module.module_azurerm_subnet["br3_fgt_priv"].subnet.id
          private_ip_address_allocation = "Static"
          private_ip_address            = cidrhost(module.module_azurerm_subnet["br3_fgt_priv"].subnet.address_prefix, 4)
          public_ip_address_id          = null
        }
      ]
    }
    "nic_br3_fortigate_1_3" = {
      resource_group_name           = module.module_azurerm_resource_group.resource_group.name
      name                          = "nic_br3_fortigate_1_3"
      location                      = module.module_azurerm_virtual_network[module.module_azurerm_subnet["br3_fgt_pub2"].subnet.virtual_network_name].virtual_network.location
      enable_ip_forwarding          = true
      enable_accelerated_networking = true

      ip_configurations = [
        {
          name                          = "ipconfig1"
          subnet_id                     = module.module_azurerm_subnet["br3_fgt_pub2"].subnet.id
          private_ip_address_allocation = "Static"
          private_ip_address            = cidrhost(module.module_azurerm_subnet["br3_fgt_pub2"].subnet.address_prefix, 14)
          public_ip_address_id          = null
        }
      ]
    }
    # Branch Linux VMs
    "nic_br1_lnx_1_1" = {
      resource_group_name           = module.module_azurerm_resource_group.resource_group.name
      name                          = "nic_br1_lnx_1_1"
      location                      = module.module_azurerm_virtual_network[module.module_azurerm_subnet["br1_protected"].subnet.virtual_network_name].virtual_network.location
      enable_ip_forwarding          = false
      enable_accelerated_networking = false

      ip_configurations = [
        {
          name                          = "ipconfig1"
          subnet_id                     = module.module_azurerm_subnet["br1_protected"].subnet.id
          private_ip_address_allocation = "Static"
          private_ip_address            = cidrhost(module.module_azurerm_subnet["br1_protected"].subnet.address_prefix, 4)
          public_ip_address_id          = null
        }
      ]
    }
    "nic_br2_lnx_1_1" = {
      resource_group_name           = module.module_azurerm_resource_group.resource_group.name
      name                          = "nic_br2_lnx_1_1"
      location                      = module.module_azurerm_virtual_network[module.module_azurerm_subnet["br2_protected"].subnet.virtual_network_name].virtual_network.location
      enable_ip_forwarding          = false
      enable_accelerated_networking = false

      ip_configurations = [
        {
          name                          = "ipconfig1"
          subnet_id                     = module.module_azurerm_subnet["br2_protected"].subnet.id
          private_ip_address_allocation = "Static"
          private_ip_address            = cidrhost(module.module_azurerm_subnet["br2_protected"].subnet.address_prefix, 4)
          public_ip_address_id          = null
        }
      ]
    }
    "nic_br3_lnx_1_1" = {
      resource_group_name           = module.module_azurerm_resource_group.resource_group.name
      name                          = "nic_br3_lnx_1_1"
      location                      = module.module_azurerm_virtual_network[module.module_azurerm_subnet["br3_protected"].subnet.virtual_network_name].virtual_network.location
      enable_ip_forwarding          = false
      enable_accelerated_networking = false

      ip_configurations = [
        {
          name                          = "ipconfig1"
          subnet_id                     = module.module_azurerm_subnet["br3_protected"].subnet.id
          private_ip_address_allocation = "Static"
          private_ip_address            = cidrhost(module.module_azurerm_subnet["br3_protected"].subnet.address_prefix, 4)
          public_ip_address_id          = null
        }
      ]
    }
    # Spoke Linux VMs
    "nic_spoke11_lnx_1_1" = {
      resource_group_name           = module.module_azurerm_resource_group.resource_group.name
      name                          = "nic_spoke11_lnx_1_1"
      location                      = module.module_azurerm_virtual_network[module.module_azurerm_subnet["spoke11_subnet1"].subnet.virtual_network_name].virtual_network.location
      enable_ip_forwarding          = false
      enable_accelerated_networking = false

      ip_configurations = [
        {
          name                          = "ipconfig1"
          subnet_id                     = module.module_azurerm_subnet["spoke11_subnet1"].subnet.id
          private_ip_address_allocation = "Static"
          private_ip_address            = cidrhost(module.module_azurerm_subnet["spoke11_subnet1"].subnet.address_prefix, 4)
          public_ip_address_id          = null
        }
      ]
    }
    "nic_spoke12_lnx_1_1" = {
      resource_group_name           = module.module_azurerm_resource_group.resource_group.name
      name                          = "nic_spoke12_lnx_1_1"
      location                      = module.module_azurerm_virtual_network[module.module_azurerm_subnet["spoke12_subnet1"].subnet.virtual_network_name].virtual_network.location
      enable_ip_forwarding          = false
      enable_accelerated_networking = false

      ip_configurations = [
        {
          name                          = "ipconfig1"
          subnet_id                     = module.module_azurerm_subnet["spoke12_subnet1"].subnet.id
          private_ip_address_allocation = "Static"
          private_ip_address            = cidrhost(module.module_azurerm_subnet["spoke12_subnet1"].subnet.address_prefix, 4)
          public_ip_address_id          = null
        }
      ]
    }
  }
}

module "module_azurerm_network_interface" {
  for_each = local.network_interfaces

  source = "../azure/rm/azurerm_network_interface"

  resource_group_name           = each.value.resource_group_name
  location                      = each.value.location
  name                          = each.value.name
  enable_ip_forwarding          = each.value.enable_ip_forwarding
  enable_accelerated_networking = each.value.enable_accelerated_networking

  ip_configurations = each.value.ip_configurations
}

output "network_interfaces" {
  value = module.module_azurerm_network_interface[*]
}
