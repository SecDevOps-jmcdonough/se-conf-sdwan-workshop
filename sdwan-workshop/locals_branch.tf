locals {
  branch_virtual_networks = {
    "vnet_branch1" = {
      resource_group_name = local.resource_group_name
      location            = "eastus"
      name                = "vnet_branch1"
      address_space       = ["172.16.0.0/16"]
    }
    "vnet_branch2" = {
      resource_group_name = local.resource_group_name
      location            = "eastus"
      name                = "vnet_branch2"
      address_space       = ["172.17.0.0/16"]
    }
    "vnet_branch3" = {
      resource_group_name = local.resource_group_name
      location            = "southcentralus"
      name                = "vnet_branch3"
      address_space       = ["172.18.0.0/16"]
    }
  }

  branch_subnets = {
    # Branch 1
    "br1_fgt_pub1" = {
      resource_group_name = local.resource_group_name
      name                = "br1_fgt_pub1"
      address_prefixes    = [cidrsubnet(module.module_azurerm_virtual_network["vnet_branch1"].virtual_network.address_space[0], 8, 1)]
      vnet_name           = "vnet_branch1"
    }
    "br1_fgt_pub2" = {
      resource_group_name = local.resource_group_name
      name                = "br1_fgt_pub2"
      address_prefixes    = [cidrsubnet(module.module_azurerm_virtual_network["vnet_branch1"].virtual_network.address_space[0], 8, 11)],
      vnet_name           = "vnet_branch1"
    }
    "br1_fgt_priv" = {
      resource_group_name = local.resource_group_name
      name                = "br1_fgt_priv"
      address_prefixes    = [cidrsubnet(module.module_azurerm_virtual_network["vnet_branch1"].virtual_network.address_space[0], 8, 2)]
      vnet_name           = "vnet_branch1"
    }
    "br1_fgt_ha" = {
      resource_group_name = local.resource_group_name
      name                = "br1_fgt_ha"
      address_prefixes    = [cidrsubnet(module.module_azurerm_virtual_network["vnet_branch1"].virtual_network.address_space[0], 8, 3)]
      vnet_name           = "vnet_branch1"
    }
    "br1_fgt_mgmt" = {
      resource_group_name = local.resource_group_name
      name                = "br1_fgt_mgmt"
      address_prefixes    = [cidrsubnet(module.module_azurerm_virtual_network["vnet_branch1"].virtual_network.address_space[0], 8, 4)]
      vnet_name           = "vnet_branch1"
    }
    "br1_protected" = {
      resource_group_name = local.resource_group_name
      name                = "br1_protected"
      address_prefixes    = [cidrsubnet(module.module_azurerm_virtual_network["vnet_branch1"].virtual_network.address_space[0], 8, 5)]
      vnet_name           = "vnet_branch1"
    }

    # Branch 2
    "br2_fgt_pub1" = {
      resource_group_name = local.resource_group_name
      name                = "br2_fgt_pub1"
      address_prefixes    = [cidrsubnet(module.module_azurerm_virtual_network["vnet_branch2"].virtual_network.address_space[0], 8, 1)]
      vnet_name           = "vnet_branch2"
    }
    "br2_fgt_pub2" = {
      resource_group_name = local.resource_group_name
      name                = "br2_fgt_pub2"
      address_prefixes    = [cidrsubnet(module.module_azurerm_virtual_network["vnet_branch2"].virtual_network.address_space[0], 8, 11)]
      vnet_name           = "vnet_branch2"
    }
    "br2_fgt_priv" = {
      resource_group_name = local.resource_group_name
      name                = "br2_fgt_priv"
      address_prefixes    = [cidrsubnet(module.module_azurerm_virtual_network["vnet_branch2"].virtual_network.address_space[0], 8, 2)]
      vnet_name           = "vnet_branch2"
    }
    "br2_fgt_ha" = {
      resource_group_name = local.resource_group_name
      name                = "br2_fgt_ha"
      address_prefixes    = [cidrsubnet(module.module_azurerm_virtual_network["vnet_branch2"].virtual_network.address_space[0], 8, 3)]
      vnet_name           = "vnet_branch2"
    }
    "br2_fgt_mgmt" = {
      resource_group_name = local.resource_group_name
      name                = "br2_fgt_mgmt"
      address_prefixes    = [cidrsubnet(module.module_azurerm_virtual_network["vnet_branch2"].virtual_network.address_space[0], 8, 4)]
      vnet_name           = "vnet_branch2"
    }
    "br2_protected" = {
      resource_group_name = local.resource_group_name
      name                = "br2_protected"
      address_prefixes    = [cidrsubnet(module.module_azurerm_virtual_network["vnet_branch2"].virtual_network.address_space[0], 8, 5)]
      vnet_name           = "vnet_branch2"
    }

    # Branch 3
    "br3_fgt_pub1" = {
      resource_group_name = local.resource_group_name
      name                = "br3_fgt_pub1"
      address_prefixes    = [cidrsubnet(module.module_azurerm_virtual_network["vnet_branch3"].virtual_network.address_space[0], 8, 1)]
      vnet_name           = "vnet_branch3"
    }
    "br3_fgt_pub2" = {
      resource_group_name = local.resource_group_name
      name                = "br3_fgt_pub2"
      address_prefixes    = [cidrsubnet(module.module_azurerm_virtual_network["vnet_branch3"].virtual_network.address_space[0], 8, 11)]
      vnet_name           = "vnet_branch3"
    }
    "br3_fgt_priv" = {
      resource_group_name = local.resource_group_name
      name                = "br3_fgt_priv"
      address_prefixes    = [cidrsubnet(module.module_azurerm_virtual_network["vnet_branch3"].virtual_network.address_space[0], 8, 2)]
      vnet_name           = "vnet_branch3"
    }
    "br3_protected" = {
      resource_group_name = local.resource_group_name
      name                = "br3_protected"
      address_prefixes    = [cidrsubnet(module.module_azurerm_virtual_network["vnet_branch3"].virtual_network.address_space[0], 8, 5)]
      vnet_name           = "vnet_branch3"
    }
  }

  branch_virtual_network_peerings = {
    # Add Virtual network peerings
  }

  branch_network_interfaces = {
    # Branch 1
    "nic_br1_fortigate_1_1" = {
      resource_group_name           = local.resource_group_name
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
      resource_group_name           = local.resource_group_name
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
      resource_group_name           = local.resource_group_name
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
      resource_group_name           = local.resource_group_name
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
      resource_group_name           = local.resource_group_name
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
      resource_group_name           = local.resource_group_name
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
      resource_group_name           = local.resource_group_name
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
      resource_group_name           = local.resource_group_name
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
      resource_group_name           = local.resource_group_name
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
      resource_group_name           = local.resource_group_name
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
      resource_group_name           = local.resource_group_name
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
      resource_group_name           = local.resource_group_name
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
      resource_group_name           = local.resource_group_name
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
      resource_group_name           = local.resource_group_name
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
      resource_group_name           = local.resource_group_name
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
      resource_group_name           = local.resource_group_name
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
      resource_group_name           = local.resource_group_name
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
      resource_group_name           = local.resource_group_name
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
      resource_group_name           = local.resource_group_name
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
      resource_group_name           = local.resource_group_name
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
      resource_group_name           = local.resource_group_name
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
      resource_group_name           = local.resource_group_name
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
      resource_group_name           = local.resource_group_name
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
      resource_group_name           = local.resource_group_name
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
      resource_group_name           = local.resource_group_name
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
      resource_group_name           = local.resource_group_name
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
  }

  branch_public_ips = {
    # Branch 1
    "pip_br1_elb_01" = {
      resource_group_name = local.resource_group_name
      name                = "pip_br1_elb_01"
      location            = module.module_azurerm_virtual_network["vnet_branch1"].virtual_network.location
      allocation_method   = "Static"
      sku                 = "Standard"
    }
    "pip_br1_elb_02" = {
      resource_group_name = local.resource_group_name
      name                = "pip_br1_elb_02"
      location            = module.module_azurerm_virtual_network["vnet_branch1"].virtual_network.location
      allocation_method   = "Static"
      sku                 = "Standard"
    }
    "pip_br2_elb_01" = {
      resource_group_name = local.resource_group_name
      name                = "pip_br2_elb_01"
      location            = module.module_azurerm_virtual_network["vnet_branch2"].virtual_network.location
      allocation_method   = "Static"
      sku                 = "Standard"
    }
    "pip_br2_elb_02" = {
      resource_group_name = local.resource_group_name
      name                = "pip_br2_elb_02"
      location            = module.module_azurerm_virtual_network["vnet_branch2"].virtual_network.location
      allocation_method   = "Static"
      sku                 = "Standard"
    }
    "pip_br3_01" = {
      resource_group_name = local.resource_group_name
      name                = "pip_br3_01"
      location            = module.module_azurerm_virtual_network["vnet_branch3"].virtual_network.location
      allocation_method   = "Static"
      sku                 = "Standard"
    }
    "pip_br3_02" = {
      resource_group_name = local.resource_group_name
      name                = "pip_br3_02"
      location            = module.module_azurerm_virtual_network["vnet_branch3"].virtual_network.location
      allocation_method   = "Static"
      sku                 = "Standard"
    }
  }

  branch_availability_sets = {
    "as_br1" = {
      resource_group_name          = local.resource_group_name
      location                     = module.module_azurerm_virtual_network["vnet_branch1"].virtual_network.location
      name                         = "as_br1"
      platform_update_domain_count = "2"
      platform_fault_domain_count  = "2"
      proximity_placement_group_id = null
      managed                      = true
    }
    "as_br2" = {
      resource_group_name          = local.resource_group_name
      location                     = module.module_azurerm_virtual_network["vnet_branch2"].virtual_network.location
      name                         = "as_br2"
      platform_update_domain_count = "2"
      platform_fault_domain_count  = "2"
      proximity_placement_group_id = null
      managed                      = true
    }
  }

  branch_lbs = {
    "lb_branch1_ext_01" = {
      resource_group_name = local.resource_group_name
      location            = module.module_azurerm_virtual_network["vnet_branch1"].virtual_network.location
      name                = "lb_branch1_ext_01"
      sku                 = "standard"
      frontend_ip_configurations = [
        {
          name                 = "pip_br1_elb_01"
          public_ip_address_id = module.module_azurerm_public_ip["pip_br1_elb_01"].public_ip.id
        },
        {
          name                 = "pip_br1_elb_02"
          public_ip_address_id = module.module_azurerm_public_ip["pip_br1_elb_02"].public_ip.id
        }
      ]
    }
    "lb_branch2_ext_01" = {
      resource_group_name = local.resource_group_name
      location            = module.module_azurerm_virtual_network["vnet_branch2"].virtual_network.location
      name                = "lb_branch2_ext_01"
      sku                 = "standard"
      frontend_ip_configurations = [
        {
          name                 = "pip_br2_elb_01"
          public_ip_address_id = module.module_azurerm_public_ip["pip_br2_elb_01"].public_ip.id
        },
        {
          name                 = "pip_br2_elb_02"
          public_ip_address_id = module.module_azurerm_public_ip["pip_br2_elb_02"].public_ip.id
        }
      ]
    }
    "lb_branch1_int_01" = {
      resource_group_name = local.resource_group_name
      location            = module.module_azurerm_virtual_network["vnet_branch1"].virtual_network.location
      name                = "lb_branch1_int_01"
      sku                 = "standard"
      frontend_ip_configurations = [
        {
          name                          = "lb_branch1_int_fe_ip_01"
          subnet_id                     = module.module_azurerm_subnet["br1_fgt_priv"].subnet.id
          vnet_name                     = module.module_azurerm_virtual_network["vnet_branch1"].virtual_network.name
          private_ip_address            = cidrhost(module.module_azurerm_subnet["br1_fgt_priv"].subnet.address_prefix, 10)
          private_ip_address_allocation = "Static"
          private_ip_address_version    = "IPv4"
        }
      ]
    }
    "lb_branch2_int_01" = {
      resource_group_name = local.resource_group_name
      location            = module.module_azurerm_virtual_network["vnet_branch2"].virtual_network.location
      name                = "lb_branch2_int_01"
      sku                 = "standard"
      frontend_ip_configurations = [
        {
          name                          = "lb_branch2_int_fe_ip_01"
          subnet_id                     = module.module_azurerm_subnet["br2_fgt_priv"].subnet.id
          vnet_name                     = module.module_azurerm_virtual_network["vnet_branch2"].virtual_network.name
          private_ip_address            = cidrhost(module.module_azurerm_subnet["br2_fgt_priv"].subnet.address_prefix, 10)
          private_ip_address_allocation = "Static"
          private_ip_address_version    = "IPv4"
        }
      ]
    }
  }

  branch_lb_backend_address_pools = {
    "lb_pool_br1_ext_01_01" = {
      name            = "lb_pool_br1_ext_01_01"
      loadbalancer_id = module.module_azurerm_lb["lb_branch1_ext_01"].lb.id
    }
    "lb_pool_br1_ext_01_02" = {
      name            = "lb_pool_br1_ext_01_02"
      loadbalancer_id = module.module_azurerm_lb["lb_branch1_ext_01"].lb.id
    }
    "lb_pool_br1_int_01_01" = {
      name            = "lb_pool_br1_int_01_01"
      loadbalancer_id = module.module_azurerm_lb["lb_branch1_int_01"].lb.id
    }
    "lb_pool_br2_ext_01_01" = {
      name            = "lb_pool_br2_ext_01_01"
      loadbalancer_id = module.module_azurerm_lb["lb_branch2_ext_01"].lb.id
    }
    "lb_pool_br2_ext_01_02" = {
      name            = "lb_pool_br2_ext_01_02"
      loadbalancer_id = module.module_azurerm_lb["lb_branch2_ext_01"].lb.id
    }
    "lb_pool_br2_int_01_01" = {
      name            = "lb_pool_br2_int_01_01"
      loadbalancer_id = module.module_azurerm_lb["lb_branch2_int_01"].lb.id
    }
  }

  branch_lb_nat_rules = {
    # Branch 1
    "br1_fgt1_https" = {
      resource_group_name = local.resource_group_name
      name                           = "br1_fgt1_https"
      loadbalancer_id                = module.module_azurerm_lb["lb_branch1_ext_01"].lb.id
      protocol                       = "Tcp"
      frontend_port                  = "1443"
      backend_port                   = "34443"
      frontend_ip_configuration_name = "pip_br1_elb_01"
    }
    "br1_fgt2_https" = {
      resource_group_name = local.resource_group_name
      name                           = "br1_fgt2_https"
      loadbalancer_id                = module.module_azurerm_lb["lb_branch1_ext_01"].lb.id
      protocol                       = "Tcp"
      frontend_port                  = "2443"
      backend_port                   = "34443"
      frontend_ip_configuration_name = "pip_br1_elb_01"
    }
    "br1_fgt1_ssh" = {
      resource_group_name = local.resource_group_name
      name                           = "br1_fgt1_ssh"
      loadbalancer_id                = module.module_azurerm_lb["lb_branch1_ext_01"].lb.id
      protocol                       = "Tcp"
      frontend_port                  = "1422"
      backend_port                   = "3422"
      frontend_ip_configuration_name = "pip_br1_elb_01"
    }
    "br1_fgt2_ssh" = {
      resource_group_name = local.resource_group_name
      name                           = "br1_fgt2_ssh"
      loadbalancer_id                = module.module_azurerm_lb["lb_branch1_ext_01"].lb.id
      protocol                       = "Tcp"
      frontend_port                  = "2422"
      backend_port                   = "3422"
      frontend_ip_configuration_name = "pip_br1_elb_01"
    }

    # Branch 2
    "br2_fgt1_https" = {
      resource_group_name = local.resource_group_name
      name                          = "br2_fgt1_https"
      loadbalancer_id               = module.module_azurerm_lb["lb_branch2_ext_01"].lb.id
      protocol                      = "Tcp"
      frontend_port                 = "1443"
      backend_port                  = "34443",
      frontend_ip_configuration_name = "pip_br2_elb_01"
    }
    "br2_fgt2_https" = {
      resource_group_name = local.resource_group_name
      name                          = "br2_fgt2_https"
      loadbalancer_id               = module.module_azurerm_lb["lb_branch2_ext_01"].lb.id
      protocol                      = "Tcp"
      frontend_port                 = "2443"
      backend_port                  = "34443",
      frontend_ip_configuration_name = "pip_br2_elb_01"
    }
    "br2_fgt1_ssh" = {
      resource_group_name = local.resource_group_name
      name                           = "br2_fgt1_ssh"
      loadbalancer_id                = module.module_azurerm_lb["lb_branch2_ext_01"].lb.id
      protocol                       = "Tcp"
      frontend_port                  = "1422"
      backend_port                   = "3422"
      frontend_ip_configuration_name = "pip_br2_elb_01"
    }
    "br2_fgt2_ssh" = {
      resource_group_name = local.resource_group_name
      name                           = "br2_fgt2_ssh"
      loadbalancer_id                = module.module_azurerm_lb["lb_branch2_ext_01"].lb.id
      protocol                       = "Tcp"
      frontend_port                  = "2422"
      backend_port                   = "3422"
      frontend_ip_configuration_name = "pip_br2_elb_01"
    }
  }

  branch_lb_outbound_rules = {
    # Branches
    "br1_lb_outbound_rule_01" = {
      resource_group_name     = local.resource_group_name
      name                    = "br1_lb_outbound_rule_01"
      loadbalancer_id         = module.module_azurerm_lb["lb_branch1_ext_01"].lb.id
      protocol                = "All"
      backend_address_pool_id = module.module_azurerm_lb_backend_address_pool["lb_pool_br1_ext_01_01"].lb_backend_address_pool.id
      frontend_ip_configurations = [
        {
          name = "pip_br1_elb_01"
        }
      ]
    }
    "br1_lb_outbound_rule_02" = {
      resource_group_name     = local.resource_group_name
      name                    = "br1_lb_outbound_rule_02"
      loadbalancer_id         = module.module_azurerm_lb["lb_branch1_ext_01"].lb.id
      protocol                = "All"
      backend_address_pool_id = module.module_azurerm_lb_backend_address_pool["lb_pool_br1_ext_01_02"].lb_backend_address_pool.id
      frontend_ip_configurations = [
        {
          name = "pip_br1_elb_02"
        }
      ]
    }
    "br2_lb_outbound_rule_01" = {
      resource_group_name     = local.resource_group_name
      name                    = "br2_lb_outbound_rule_01"
      loadbalancer_id         = module.module_azurerm_lb["lb_branch2_ext_01"].lb.id
      protocol                = "All"
      backend_address_pool_id = module.module_azurerm_lb_backend_address_pool["lb_pool_br2_ext_01_01"].lb_backend_address_pool.id
      frontend_ip_configurations = [
        {
          name = "pip_br2_elb_01"
        }
      ]
    }
    "br2_lb_outbound_rule_02" = {
      resource_group_name     = local.resource_group_name
      name                    = "br2_lb_outbound_rule_02"
      loadbalancer_id         = module.module_azurerm_lb["lb_branch2_ext_01"].lb.id
      protocol                = "All"
      backend_address_pool_id = module.module_azurerm_lb_backend_address_pool["lb_pool_br2_ext_01_02"].lb_backend_address_pool.id
      frontend_ip_configurations = [
        {
          name = "pip_br2_elb_02"
        }
      ]
    }
  }

  branch_lb_probes = {
    "lb_probe_br1_ext_lb_01" = {
      resource_group_name = local.resource_group_name
      name                = "lb_probe_br1_ext_lb_01"
      loadbalancer_id     = module.module_azurerm_lb["lb_branch1_ext_01"].lb.id
      port                = "8008"
    }
    "lb_probe_br1_int_lb_01" = {
      resource_group_name = local.resource_group_name
      name                = "lb_probe_br1_int_lb_01"
      loadbalancer_id     = module.module_azurerm_lb["lb_branch1_int_01"].lb.id
      port                = "8008"
    }
    "lb_probe_br2_ext_lb_01" = {
      resource_group_name = local.resource_group_name
      name                = "lb_probe_br2_ext_lb_01"
      loadbalancer_id     = module.module_azurerm_lb["lb_branch2_ext_01"].lb.id
      port                = "8008"
    }
    "lb_probe_br2_int_lb_01" = {
      resource_group_name = local.resource_group_name
      name                = "lb_probe_br2_int_lb_01"
      loadbalancer_id     = module.module_azurerm_lb["lb_branch2_int_01"].lb.id
      port                = "8008"
    }
  }

  branch_lb_rules = {
    # Branch 1
    # External
    "lb_rule_br1_ext_udp_500_isp1" = {
      resource_group_name            = local.resource_group_name
      name                           = "lb_rule_br1_ext_udp_500_isp1"
      loadbalancer_id                = module.module_azurerm_lb["lb_branch1_ext_01"].lb.id
      frontend_ip_configuration_name = "pip_br1_elb_01"
      protocol                       = "Udp"
      frontend_port                  = "500"
      backend_port                   = "500"
      backend_address_pool_ids       = [module.module_azurerm_lb_backend_address_pool["lb_pool_br1_ext_01_01"].lb_backend_address_pool.id]
      probe_id                       = module.module_azurerm_lb_probe["lb_probe_br1_ext_lb_01"].lb_probe.id
      disable_outbound_snat          = true
    }
    "lb_rule_br1_ext_udp_4500_isp1" = {
      resource_group_name            = local.resource_group_name
      name                           = "lb_rule_br1_ext_udp_4500_isp1"
      loadbalancer_id                = module.module_azurerm_lb["lb_branch1_ext_01"].lb.id
      frontend_ip_configuration_name = "pip_br1_elb_01"
      protocol                       = "Udp"
      frontend_port                  = "4500"
      backend_port                   = "4500"
      backend_address_pool_ids       = [module.module_azurerm_lb_backend_address_pool["lb_pool_br1_ext_01_01"].lb_backend_address_pool.id]
      probe_id                       = module.module_azurerm_lb_probe["lb_probe_br1_ext_lb_01"].lb_probe.id
      disable_outbound_snat          = true
    }
    "lb_rule_br1_ext_udp_500_isp2" = {
      resource_group_name            = local.resource_group_name
      name                           = "lb_rule_br1_ext_udp_500_isp2"
      loadbalancer_id                = module.module_azurerm_lb["lb_branch1_ext_01"].lb.id
      frontend_ip_configuration_name = "pip_br1_elb_02"
      protocol                       = "Udp"
      frontend_port                  = "500"
      backend_port                   = "500"
      backend_address_pool_ids       = [module.module_azurerm_lb_backend_address_pool["lb_pool_br1_ext_01_02"].lb_backend_address_pool.id]
      probe_id                       = module.module_azurerm_lb_probe["lb_probe_br1_ext_lb_01"].lb_probe.id
      disable_outbound_snat          = true
    }
    "lb_rule_br1_ext_udp_4500_isp2" = {
      resource_group_name            = local.resource_group_name
      name                           = "lb_rule_br1_ext_udp_4500_isp2"
      loadbalancer_id                = module.module_azurerm_lb["lb_branch1_ext_01"].lb.id
      frontend_ip_configuration_name = "pip_br1_elb_02"
      protocol                       = "Udp"
      frontend_port                  = "4500"
      backend_port                   = "4500"
      backend_address_pool_ids       = [module.module_azurerm_lb_backend_address_pool["lb_pool_br1_ext_01_02"].lb_backend_address_pool.id]
      probe_id                       = module.module_azurerm_lb_probe["lb_probe_br1_ext_lb_01"].lb_probe.id
      disable_outbound_snat          = true
    }

    # Internal
    "lb_rule_br1_int_fgt_haports" = {
      resource_group_name            = local.resource_group_name
      name                           = "lb_rule_br1_int_fgt_haports"
      loadbalancer_id                = module.module_azurerm_lb["lb_branch1_int_01"].lb.id
      frontend_ip_configuration_name = "lb_branch1_int_fe_ip_01"
      protocol                       = "All"
      frontend_port                  = "0"
      backend_port                   = "0"
      backend_address_pool_ids       = [module.module_azurerm_lb_backend_address_pool["lb_pool_br1_int_01_01"].lb_backend_address_pool.id]
      probe_id                       = module.module_azurerm_lb_probe["lb_probe_br1_int_lb_01"].lb_probe.id
      disable_outbound_snat          = true
    }

    # Branch 2
    # External
    "lb_rule_br2_ext_udp_500_isp1" = {
      resource_group_name            = local.resource_group_name
      name                           = "lb_rule_br2_ext_udp_500_isp1"
      loadbalancer_id                = module.module_azurerm_lb["lb_branch2_ext_01"].lb.id
      frontend_ip_configuration_name = "pip_br2_elb_01"
      protocol                       = "Udp"
      frontend_port                  = "500"
      backend_port                   = "500"
      backend_address_pool_ids       = [module.module_azurerm_lb_backend_address_pool["lb_pool_br2_ext_01_01"].lb_backend_address_pool.id]
      probe_id                       = module.module_azurerm_lb_probe["lb_probe_br2_ext_lb_01"].lb_probe.id
      disable_outbound_snat          = true
    }
    "lb_rule_br2_ext_udp_4500_isp1" = {
      resource_group_name            = local.resource_group_name
      name                           = "lb_rule_br2_ext_udp_4500_isp1"
      loadbalancer_id                = module.module_azurerm_lb["lb_branch2_ext_01"].lb.id
      frontend_ip_configuration_name = "pip_br2_elb_01"
      protocol                       = "Udp"
      frontend_port                  = "4500"
      backend_port                   = "4500"
      backend_address_pool_ids       = [module.module_azurerm_lb_backend_address_pool["lb_pool_br2_ext_01_01"].lb_backend_address_pool.id]
      probe_id                       = module.module_azurerm_lb_probe["lb_probe_br2_ext_lb_01"].lb_probe.id
      disable_outbound_snat          = true
    }
    "lb_rule_br2_ext_udp_500_isp2" = {
      resource_group_name            = local.resource_group_name
      name                           = "lb_rule_br2_ext_udp_500_isp2"
      loadbalancer_id                = module.module_azurerm_lb["lb_branch2_ext_01"].lb.id
      frontend_ip_configuration_name = "pip_br2_elb_02"
      protocol                       = "Udp"
      frontend_port                  = "500"
      backend_port                   = "500"
      backend_address_pool_ids       = [module.module_azurerm_lb_backend_address_pool["lb_pool_br2_ext_01_02"].lb_backend_address_pool.id]
      probe_id                       = module.module_azurerm_lb_probe["lb_probe_br2_ext_lb_01"].lb_probe.id
      disable_outbound_snat          = true
    }
    "lb_rule_br2_ext_udp_4500_isp2" = {
      resource_group_name            = local.resource_group_name
      name                           = "lb_rule_br2_ext_udp_4500_isp2"
      loadbalancer_id                = module.module_azurerm_lb["lb_branch2_ext_01"].lb.id
      frontend_ip_configuration_name = "pip_br2_elb_02"
      protocol                       = "Udp"
      frontend_port                  = "4500"
      backend_port                   = "4500"
      backend_address_pool_ids       = [module.module_azurerm_lb_backend_address_pool["lb_pool_br2_ext_01_02"].lb_backend_address_pool.id]
      probe_id                       = module.module_azurerm_lb_probe["lb_probe_br2_ext_lb_01"].lb_probe.id
      disable_outbound_snat          = true
    }

    # Internal
    "lb_rule_br2_int_fgt_haports" = {
      resource_group_name            = local.resource_group_name
      name                           = "lb_rule_br2_int_fgt_haports"
      loadbalancer_id                = module.module_azurerm_lb["lb_branch2_int_01"].lb.id
      frontend_ip_configuration_name = "lb_branch2_int_fe_ip_01"
      protocol                       = "All"
      frontend_port                  = "0"
      backend_port                   = "0"
      backend_address_pool_ids       = [module.module_azurerm_lb_backend_address_pool["lb_pool_br2_int_01_01"].lb_backend_address_pool.id]
      probe_id                       = module.module_azurerm_lb_probe["lb_probe_br2_int_lb_01"].lb_probe.id
      disable_outbound_snat          = true
    }
  }

  branch_network_interface_backend_address_pool_associations = {
    # Branch 1
    "nic_br1_fortigate_1_1" = {
      network_interface_id    = module.module_azurerm_network_interface["nic_br1_fortigate_1_1"].network_interface.id
      ip_configuration_name   = "ipconfig1"
      backend_address_pool_id = module.module_azurerm_lb_backend_address_pool["lb_pool_br1_ext_01_01"].lb_backend_address_pool.id
    }
    "nic_br1_fortigate_1_2" = {
      network_interface_id    = module.module_azurerm_network_interface["nic_br1_fortigate_1_2"].network_interface.id
      ip_configuration_name   = "ipconfig1"
      backend_address_pool_id = module.module_azurerm_lb_backend_address_pool["lb_pool_br1_int_01_01"].lb_backend_address_pool.id
    }
    "nic_br1_fortigate_1_3" = {
      network_interface_id    = module.module_azurerm_network_interface["nic_br1_fortigate_1_3"].network_interface.id
      ip_configuration_name   = "ipconfig1"
      backend_address_pool_id = module.module_azurerm_lb_backend_address_pool["lb_pool_br1_ext_01_02"].lb_backend_address_pool.id
    }
    "nic_br1_fortigate_2_1" = {
      network_interface_id    = module.module_azurerm_network_interface["nic_br1_fortigate_2_1"].network_interface.id
      ip_configuration_name   = "ipconfig1"
      backend_address_pool_id = module.module_azurerm_lb_backend_address_pool["lb_pool_br1_ext_01_01"].lb_backend_address_pool.id
    }
    "nic_br1_fortigate_2_2" = {
      network_interface_id    = module.module_azurerm_network_interface["nic_br1_fortigate_2_2"].network_interface.id
      ip_configuration_name   = "ipconfig1"
      backend_address_pool_id = module.module_azurerm_lb_backend_address_pool["lb_pool_br1_int_01_01"].lb_backend_address_pool.id
    }
    "nic_br1_fortigate_2_3" = {
      network_interface_id    = module.module_azurerm_network_interface["nic_br1_fortigate_2_3"].network_interface.id
      ip_configuration_name   = "ipconfig1"
      backend_address_pool_id = module.module_azurerm_lb_backend_address_pool["lb_pool_br1_ext_01_02"].lb_backend_address_pool.id
    }
    "nic_br2_fortigate_1_1" = {
      network_interface_id    = module.module_azurerm_network_interface["nic_br2_fortigate_1_1"].network_interface.id
      ip_configuration_name   = "ipconfig1"
      backend_address_pool_id = module.module_azurerm_lb_backend_address_pool["lb_pool_br2_ext_01_01"].lb_backend_address_pool.id
    }
    "nic_br2_fortigate_1_2" = {
      network_interface_id    = module.module_azurerm_network_interface["nic_br2_fortigate_1_2"].network_interface.id
      ip_configuration_name   = "ipconfig1"
      backend_address_pool_id = module.module_azurerm_lb_backend_address_pool["lb_pool_br2_int_01_01"].lb_backend_address_pool.id
    }
    "nic_br2_fortigate_1_3" = {
      network_interface_id    = module.module_azurerm_network_interface["nic_br2_fortigate_1_3"].network_interface.id
      ip_configuration_name   = "ipconfig1"
      backend_address_pool_id = module.module_azurerm_lb_backend_address_pool["lb_pool_br2_ext_01_02"].lb_backend_address_pool.id
    }
    "nic_br2_fortigate_2_1" = {
      network_interface_id    = module.module_azurerm_network_interface["nic_br2_fortigate_2_1"].network_interface.id
      ip_configuration_name   = "ipconfig1"
      backend_address_pool_id = module.module_azurerm_lb_backend_address_pool["lb_pool_br2_ext_01_01"].lb_backend_address_pool.id
    }
    "nic_br2_fortigate_2_2" = {
      network_interface_id    = module.module_azurerm_network_interface["nic_br2_fortigate_2_2"].network_interface.id
      ip_configuration_name   = "ipconfig1"
      backend_address_pool_id = module.module_azurerm_lb_backend_address_pool["lb_pool_br2_int_01_01"].lb_backend_address_pool.id
    }
    "nic_br2_fortigate_2_3" = {
      network_interface_id    = module.module_azurerm_network_interface["nic_br2_fortigate_2_3"].network_interface.id
      ip_configuration_name   = "ipconfig1"
      backend_address_pool_id = module.module_azurerm_lb_backend_address_pool["lb_pool_br2_ext_01_02"].lb_backend_address_pool.id
    }
  }

  branch_network_interface_nat_rule_associations = {
    "br1_fgt1_https" = {
      network_interface_id  = module.module_azurerm_network_interface["nic_br1_fortigate_1_5"].network_interface.id
      ip_configuration_name = "ipconfig1"
      nat_rule_id           = module.module_azurerm_lb_nat_rule["br1_fgt1_https"].lb_nat_rule.id
    }
    "br1_fgt2_https" = {
      network_interface_id  = module.module_azurerm_network_interface["nic_br1_fortigate_2_5"].network_interface.id
      ip_configuration_name = "ipconfig1"
      nat_rule_id           = module.module_azurerm_lb_nat_rule["br1_fgt2_https"].lb_nat_rule.id
    }
    "br1_fgt1_ssh" = {
      network_interface_id  = module.module_azurerm_network_interface["nic_br1_fortigate_1_5"].network_interface.id
      ip_configuration_name = "ipconfig1"
      nat_rule_id           = module.module_azurerm_lb_nat_rule["br1_fgt1_ssh"].lb_nat_rule.id
    }
    "br1_fgt2_ssh" = {
      network_interface_id  = module.module_azurerm_network_interface["nic_br1_fortigate_2_5"].network_interface.id
      ip_configuration_name = "ipconfig1"
      nat_rule_id           = module.module_azurerm_lb_nat_rule["br1_fgt2_ssh"].lb_nat_rule.id
    }
    "br2_fgt1_https" = {
      network_interface_id  = module.module_azurerm_network_interface["nic_br2_fortigate_1_5"].network_interface.id
      ip_configuration_name = "ipconfig1"
      nat_rule_id           = module.module_azurerm_lb_nat_rule["br2_fgt1_https"].lb_nat_rule.id
    }
    "br2_fgt2_https" = {
      network_interface_id  = module.module_azurerm_network_interface["nic_br2_fortigate_2_5"].network_interface.id
      ip_configuration_name = "ipconfig1"
      nat_rule_id           = module.module_azurerm_lb_nat_rule["br2_fgt2_https"].lb_nat_rule.id
    }
    "br2_fgt1_ssh" = {
      network_interface_id  = module.module_azurerm_network_interface["nic_br2_fortigate_1_5"].network_interface.id
      ip_configuration_name = "ipconfig1"
      nat_rule_id           = module.module_azurerm_lb_nat_rule["br2_fgt1_ssh"].lb_nat_rule.id
    }
    "br2_fgt2_ssh" = {
      network_interface_id  = module.module_azurerm_network_interface["nic_br2_fortigate_2_5"].network_interface.id
      ip_configuration_name = "ipconfig1"
      nat_rule_id           = module.module_azurerm_lb_nat_rule["br2_fgt2_ssh"].lb_nat_rule.id
    }
  }

  branch_network_security_groups = {
    "nsg_br1" = {
      resource_group_name = local.resource_group_name
      name                = "nsg_br1"
      vnet_name           = module.module_azurerm_virtual_network["vnet_branch1"].virtual_network.location
    }
    "nsg_br2" = {
      resource_group_name = local.resource_group_name
      name                = "nsg_br2"
      vnet_name           = module.module_azurerm_virtual_network["vnet_branch2"].virtual_network.location
    }
    "nsg_br3" = {
      resource_group_name = local.resource_group_name
      name                = "nsg_br3"
      vnet_name           = module.module_azurerm_virtual_network["vnet_branch3"].virtual_network.location
    }
  }

  branch_network_security_rules = {
    "br1_all_inbound" = {
      resource_group_name         = local.resource_group_name
      name                        = "br1_all_inbound"
      network_security_group_name = module.module_azurerm_network_security_group["nsg_br1"].network_security_group.name
      priority                    = "100"
      direction                   = "Inbound"
      access                      = "Allow"
      protocol                    = "*"
    }
    "br1_all_outbound" = {
      resource_group_name         = local.resource_group_name
      name                        = "br1_all_outbound"
      network_security_group_name = module.module_azurerm_network_security_group["nsg_br1"].network_security_group.name
      priority                    = "100"
      direction                   = "Outbound"
      access                      = "Allow"
      protocol                    = "*"
    }
    "br2_all_inbound" = {
      resource_group_name         = local.resource_group_name
      name                        = "br2_all_inbound"
      network_security_group_name = module.module_azurerm_network_security_group["nsg_br2"].network_security_group.name
      priority                    = "100"
      direction                   = "Inbound"
      access                      = "Allow"
      protocol                    = "*"
    }
    "br2_all_outbound" = {
      resource_group_name         = local.resource_group_name
      name                        = "br2_all_outbound"
      network_security_group_name = module.module_azurerm_network_security_group["nsg_br2"].network_security_group.name
      priority                    = "100"
      direction                   = "Outbound"
      access                      = "Allow"
      protocol                    = "*"
    }
    "br3_all_inbound" = {
      resource_group_name         = local.resource_group_name
      name                        = "br3_all_inbound"
      network_security_group_name = module.module_azurerm_network_security_group["nsg_br3"].network_security_group.name
      priority                    = "100"
      direction                   = "Inbound"
      access                      = "Allow"
      protocol                    = "*"
    }
    "br3_all_outbound" = {
      resource_group_name         = local.resource_group_name
      name                        = "br3_all_outbound"
      network_security_group_name = module.module_azurerm_network_security_group["nsg_br3"].network_security_group.name
      priority                    = "100"
      direction                   = "Outbound"
      access                      = "Allow"
      protocol                    = "*"
    }
  }

  branch_network_interface_security_group_associations = {
  }

  branch_subnet_network_security_group_associations = {
    "br1_fgt_pub1" = {
      subnet_id                 = module.module_azurerm_subnet["br1_fgt_pub1"].subnet.id
      network_security_group_id = module.module_azurerm_network_security_group["nsg_br1"].network_security_group.id
    }
    "br1_fgt_pub2" = {
      subnet_id                 = module.module_azurerm_subnet["br1_fgt_pub2"].subnet.id
      network_security_group_id = module.module_azurerm_network_security_group["nsg_br1"].network_security_group.id
    }
    "br1_fgt_priv" = {
      subnet_id                 = module.module_azurerm_subnet["br1_fgt_priv"].subnet.id
      network_security_group_id = module.module_azurerm_network_security_group["nsg_br1"].network_security_group.id
    }
    "br1_fgt_ha" = {
      subnet_id                 = module.module_azurerm_subnet["br1_fgt_ha"].subnet.id
      network_security_group_id = module.module_azurerm_network_security_group["nsg_br1"].network_security_group.id
    }
    "br1_fgt_mgmt" = {
      subnet_id                 = module.module_azurerm_subnet["br1_fgt_mgmt"].subnet.id
      network_security_group_id = module.module_azurerm_network_security_group["nsg_br1"].network_security_group.id
    }
    "br1_protected" = {
      subnet_id                 = module.module_azurerm_subnet["br1_protected"].subnet.id
      network_security_group_id = module.module_azurerm_network_security_group["nsg_br1"].network_security_group.id
    }
    "br2_fgt_pub1" = {
      subnet_id                 = module.module_azurerm_subnet["br2_fgt_pub1"].subnet.id
      network_security_group_id = module.module_azurerm_network_security_group["nsg_br2"].network_security_group.id
    }
    "br2_fgt_pub2" = {
      subnet_id                 = module.module_azurerm_subnet["br2_fgt_pub2"].subnet.id
      network_security_group_id = module.module_azurerm_network_security_group["nsg_br2"].network_security_group.id
    }
    "br2_fgt_priv" = {
      subnet_id                 = module.module_azurerm_subnet["br2_fgt_priv"].subnet.id
      network_security_group_id = module.module_azurerm_network_security_group["nsg_br2"].network_security_group.id
    }
    "br2_fgt_ha" = {
      subnet_id                 = module.module_azurerm_subnet["br2_fgt_ha"].subnet.id
      network_security_group_id = module.module_azurerm_network_security_group["nsg_br2"].network_security_group.id
    }
    "br2_fgt_mgmt" = {
      subnet_id                 = module.module_azurerm_subnet["br2_fgt_mgmt"].subnet.id
      network_security_group_id = module.module_azurerm_network_security_group["nsg_br2"].network_security_group.id
    }
    "br2_protected" = {
      subnet_id                 = module.module_azurerm_subnet["br2_protected"].subnet.id
      network_security_group_id = module.module_azurerm_network_security_group["nsg_br2"].network_security_group.id
    }
    "br3_fgt_pub1" = {
      subnet_id                 = module.module_azurerm_subnet["br3_fgt_pub1"].subnet.id
      network_security_group_id = module.module_azurerm_network_security_group["nsg_br3"].network_security_group.id
    }
    "br3_fgt_pub2" = {
      subnet_id                 = module.module_azurerm_subnet["br3_fgt_pub2"].subnet.id
      network_security_group_id = module.module_azurerm_network_security_group["nsg_br3"].network_security_group.id
    }
    "br3_fgt_priv" = {
      subnet_id                 = module.module_azurerm_subnet["br3_fgt_priv"].subnet.id
      network_security_group_id = module.module_azurerm_network_security_group["nsg_br3"].network_security_group.id
    }
    "br3_protected" = {
      subnet_id                 = module.module_azurerm_subnet["br3_protected"].subnet.id
      network_security_group_id = module.module_azurerm_network_security_group["nsg_br3"].network_security_group.id
    }
  }

  branch_storage_accounts = {
    "stbr1" = {
      resource_group_name      = local.resource_group_name
      location                 = module.module_azurerm_virtual_network["vnet_branch1"].virtual_network.location
      name                     = format("%s%s", "stbr1", "${random_id.random_id.hex}")
      account_replication_type = "LRS"
      account_tier             = "Standard"
    }
    "stbr2" = {
      resource_group_name      = local.resource_group_name
      location                 = module.module_azurerm_virtual_network["vnet_branch2"].virtual_network.location
      name                     = format("%s%s", "stbr2", "${random_id.random_id.hex}")
      account_replication_type = "LRS"
      account_tier             = "Standard"
    }
    "stbr3" = {
      resource_group_name      = local.resource_group_name
      location                 = module.module_azurerm_virtual_network["vnet_branch3"].virtual_network.location
      name                     = format("%s%s", "stbr3", "${random_id.random_id.hex}")
      account_replication_type = "LRS"
      account_tier             = "Standard"
    }
  }

  branch_route_tables = {
    "rt_br1_protected" = {
      resource_group_name           = local.resource_group_name
      name                          = "rt_br1_protected"
      vnet_name                     = module.module_azurerm_virtual_network["vnet_branch1"].virtual_network.location
      disable_bgp_route_propagation = "false"
    }
    "rt_br2_protected" = {
      resource_group_name           = local.resource_group_name
      name                          = "rt_br2_protected"
      vnet_name                     = module.module_azurerm_virtual_network["vnet_branch2"].virtual_network.location
      disable_bgp_route_propagation = "false"
    }
    "rt_br3_protected" = {
      resource_group_name           = local.resource_group_name
      name                          = "rt_br3_protected"
      vnet_name                     = module.module_azurerm_virtual_network["vnet_branch3"].virtual_network.location
      disable_bgp_route_propagation = "false"
    }
  }

  branch_subnet_route_table_associations = {
    "br1_protected" = {
      subnet_id      = module.module_azurerm_subnet["br1_protected"].subnet.id
      route_table_id = module.module_azurerm_route_table["rt_br1_protected"].route_table.id
    }
    "br2_protected" = {
      subnet_id      = module.module_azurerm_subnet["br2_protected"].subnet.id
      route_table_id = module.module_azurerm_route_table["rt_br2_protected"].route_table.id
    }
    "br3_protected" = {
      subnet_id      = module.module_azurerm_subnet["br3_protected"].subnet.id
      route_table_id = module.module_azurerm_route_table["rt_br3_protected"].route_table.id
    }
  }

  # Only define in one locals_XXX.tf file
  vm_linux_image = {
    "Canonical" = {
      publisher = "Canonical"
      offer     = "UbuntuServer"
      sku       = "18.04-LTS"
      version   = "latest"
    }
  }

  branch_linux_virtual_machines = {
    "vm_br1_lnx_1" = {
      resource_group_name = local.resource_group_name
      location            = module.module_azurerm_virtual_network["vnet_branch1"].virtual_network.location

      name = "${local.tag_project}-vm-br1-lnx-1"
      size = "Standard_D2_v3"

      availability_set_id   = null
      network_interface_ids = [for nic in ["nic_br1_lnx_1_1"] : module.module_azurerm_network_interface[nic].network_interface.id]

      admin_username = var.username
      admin_password = var.password
      computer_name  = "${local.tag_project}-vm-br1-lnx-1"

      disable_password_authentication = false

      os_disk_name                 = "${local.tag_project}-disk-br1-lnx-1-OS"
      os_disk_caching              = "ReadWrite"
      os_disk_storage_account_type = "Standard_LRS"

      allow_extension_operations = true

      storage_account_uri = module.module_azurerm_storage_account["stbr1"].storage_account.primary_blob_endpoint

      identity = "SystemAssigned"

      source_image_reference_publisher = local.vm_linux_image["Canonical"].publisher
      source_image_reference_offer     = local.vm_linux_image["Canonical"].offer
      source_image_reference_sku       = local.vm_linux_image["Canonical"].sku
      source_image_reference_version   = local.vm_linux_image["Canonical"].version

      custom_data = base64encode(templatefile("./assets/lnx-spoke.tpl", {}))

      zone = null

      tags = {
        Project = local.project
      }
    }
    "vm_br2_lnx_1" = {
      resource_group_name = local.resource_group_name
      location            = module.module_azurerm_virtual_network["vnet_branch2"].virtual_network.location

      name = "${local.tag_project}-vm-br2-lnx-1"
      size = "Standard_D2_v3"

      availability_set_id   = null
      network_interface_ids = [for nic in ["nic_br2_lnx_1_1"] : module.module_azurerm_network_interface[nic].network_interface.id]

      admin_username = var.username
      admin_password = var.password
      computer_name  = "${local.tag_project}-vm-br2-lnx-1"

      disable_password_authentication = false

      os_disk_name                 = "${local.tag_project}-disk-br2-lnx-1-OS"
      os_disk_caching              = "ReadWrite"
      os_disk_storage_account_type = "Standard_LRS"

      allow_extension_operations = true

      storage_account_uri = module.module_azurerm_storage_account["stbr2"].storage_account.primary_blob_endpoint

      identity = "SystemAssigned"

      source_image_reference_publisher = local.vm_linux_image["Canonical"].publisher
      source_image_reference_offer     = local.vm_linux_image["Canonical"].offer
      source_image_reference_sku       = local.vm_linux_image["Canonical"].sku
      source_image_reference_version   = local.vm_linux_image["Canonical"].version

      custom_data = base64encode(templatefile("./assets/lnx-spoke.tpl", {}))

      zone = null

      tags = {
        Project = local.project
      }
    }
    "vm_br3_lnx_1" = {
      resource_group_name = local.resource_group_name
      location            = module.module_azurerm_virtual_network["vnet_branch3"].virtual_network.location

      name = "${local.tag_project}-vm-br3-lnx-1"
      size = "Standard_D2_v3"

      availability_set_id   = null
      network_interface_ids = [for nic in ["nic_br3_lnx_1_1"] : module.module_azurerm_network_interface[nic].network_interface.id]

      admin_username = var.username
      admin_password = var.password
      computer_name  = "${local.tag_project}-vm-br3-lnx-1"

      disable_password_authentication = false

      os_disk_name                 = "${local.tag_project}-disk-br3-lnx-1-OS"
      os_disk_caching              = "ReadWrite"
      os_disk_storage_account_type = "Standard_LRS"

      allow_extension_operations = true

      storage_account_uri = module.module_azurerm_storage_account["stbr3"].storage_account.primary_blob_endpoint

      identity = "SystemAssigned"

      source_image_reference_publisher = local.vm_linux_image["Canonical"].publisher
      source_image_reference_offer     = local.vm_linux_image["Canonical"].offer
      source_image_reference_sku       = local.vm_linux_image["Canonical"].sku
      source_image_reference_version   = local.vm_linux_image["Canonical"].version

      custom_data = base64encode(templatefile("./assets/lnx-spoke.tpl", {}))

      zone = null

      tags = {
        Project = local.project
      }
    }
  }

  branch_virtual_machines = {
    "vm_br1_fgt_1" = {
      resource_group_name = local.resource_group_name
      location            = module.module_azurerm_virtual_network["vnet_branch1"].virtual_network.location

      name              = "${local.tag_project}-vm-br1-fgt-1"
      identity_identity = "SystemAssigned"

      availability_set_id = module.module_azurerm_availability_set["as_br1"].availability_set.id
      zones               = null

      delete_os_disk_on_termination    = true
      delete_data_disks_on_termination = true

      network_interface_ids        = [for nic in ["nic_br1_fortigate_1_1", "nic_br1_fortigate_1_2", "nic_br1_fortigate_1_3", "nic_br1_fortigate_1_4", "nic_br1_fortigate_1_5"] : module.module_azurerm_network_interface[nic].network_interface.id]
      primary_network_interface_id = module.module_azurerm_network_interface["nic_br1_fortigate_1_1"].network_interface.id

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
      boot_diagnostics_storage_uri = module.module_azurerm_storage_account["stbr1"].storage_account.primary_blob_endpoint

      storage_os_disk_name              = "${local.tag_project}-disk_os_br1_fgt_1"
      storage_os_disk_caching           = "ReadWrite"
      storage_os_disk_managed_disk_type = "Premium_LRS"
      storage_os_disk_create_option     = "FromImage"

      storage_data_disks = [
        {
          name              = "${local.tag_project}-disk_data_br1_fgt_1"
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
      config_data = templatefile("./assets/fgt-br-userdata.tpl", {
        fgt_id               = "vm-br1-fgt-1"
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
        gui_theme            = "neutrino"
        Port1IP              = module.module_azurerm_network_interface["nic_br1_fortigate_1_1"].network_interface.private_ip_address
        Port1Alias           = "isp1"
        Port2IP              = module.module_azurerm_network_interface["nic_br1_fortigate_1_2"].network_interface.private_ip_address
        Port2Alias           = "priv"
        Port3IP              = module.module_azurerm_network_interface["nic_br1_fortigate_1_3"].network_interface.private_ip_address
        Port3Alias           = "isp2"
        Port4IP              = module.module_azurerm_network_interface["nic_br1_fortigate_1_4"].network_interface.private_ip_address
        Port4Alias           = "ha"
        Port5Alias           = "mgmt"

        port1subnetmask = cidrnetmask(module.module_azurerm_subnet["br1_fgt_pub1"].subnet.address_prefix)
        port2subnetmask = cidrnetmask(module.module_azurerm_subnet["br1_fgt_priv"].subnet.address_prefix)
        port3subnetmask = cidrnetmask(module.module_azurerm_subnet["br1_fgt_pub2"].subnet.address_prefix)
        port4subnetmask = cidrnetmask(module.module_azurerm_subnet["br1_fgt_ha"].subnet.address_prefix)

        fgt_external_gw1 = cidrhost(module.module_azurerm_subnet["br1_fgt_pub1"].subnet.address_prefix, 1)
        fgt_external_gw2 = cidrhost(module.module_azurerm_subnet["br1_fgt_pub2"].subnet.address_prefix, 1)

        fgt_internal_gw = cidrhost(module.module_azurerm_subnet["br1_fgt_priv"].subnet.address_prefix, 1)
        fgt_mgmt_gw     = cidrhost(module.module_azurerm_subnet["br1_fgt_mgmt"].subnet.address_prefix, 1)

        isp2 = module.module_azurerm_network_interface["nic_br1_fortigate_1_3"].network_interface.name

        fgt_ha_peerip   = module.module_azurerm_network_interface["nic_br1_fortigate_2_4"].network_interface.private_ip_address
        fgt_ha_priority = "100"
        vnet_network    = module.module_azurerm_virtual_network["vnet_branch1"].virtual_network.address_space[0]

        port_ha   = "port4"
        port_mgmt = "port5"

        fgt_config_sdwan = true
        remotegw1        = module.module_azurerm_public_ip["pip_hub_elb_01"].public_ip.ip_address
        remotegw2        = module.module_azurerm_public_ip["pip_hub_elb_01"].public_ip.ip_address

        fgt_config_bgp = false
        fgt_as         = ""
        peer1          = ""
        peer2          = ""
        peer_as        = ""

        }
      )
    }
    "vm_br1_fgt_2" = {
      resource_group_name = local.resource_group_name
      location            = module.module_azurerm_virtual_network["vnet_branch1"].virtual_network.location

      name              = "${local.tag_project}-vm-br1-fgt-2"
      identity_identity = "SystemAssigned"

      availability_set_id = module.module_azurerm_availability_set["as_br1"].availability_set.id
      zones               = null

      delete_os_disk_on_termination    = true
      delete_data_disks_on_termination = true

      network_interface_ids        = [for nic in ["nic_br1_fortigate_2_1", "nic_br1_fortigate_2_2", "nic_br1_fortigate_2_3", "nic_br1_fortigate_2_4", "nic_br1_fortigate_2_5"] : module.module_azurerm_network_interface[nic].network_interface.id]
      primary_network_interface_id = module.module_azurerm_network_interface["nic_br1_fortigate_2_1"].network_interface.id

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
      boot_diagnostics_storage_uri = module.module_azurerm_storage_account["stbr1"].storage_account.primary_blob_endpoint

      storage_os_disk_name              = "${local.tag_project}-disk_os_br1_fgt_2"
      storage_os_disk_caching           = "ReadWrite"
      storage_os_disk_managed_disk_type = "Premium_LRS"
      storage_os_disk_create_option     = "FromImage"

      storage_data_disks = [
        {
          name              = "${local.tag_project}-disk_data_br1_fgt_2"
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
      config_data = templatefile("./assets/fgt-br-userdata.tpl", {
        fgt_id               = "vm-br1-fgt-2"
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
        gui_theme            = "neutrino"
        Port1IP              = module.module_azurerm_network_interface["nic_br1_fortigate_2_1"].network_interface.private_ip_address
        Port1Alias           = "isp1"
        Port2IP              = module.module_azurerm_network_interface["nic_br1_fortigate_2_2"].network_interface.private_ip_address
        Port2Alias           = "priv"
        Port3IP              = module.module_azurerm_network_interface["nic_br1_fortigate_2_3"].network_interface.private_ip_address
        Port3Alias           = "isp2"
        Port4IP              = module.module_azurerm_network_interface["nic_br1_fortigate_2_4"].network_interface.private_ip_address
        Port4Alias           = "ha"
        Port5Alias           = "mgmt"

        port1subnetmask = cidrnetmask(module.module_azurerm_subnet["br1_fgt_pub1"].subnet.address_prefix)
        port2subnetmask = cidrnetmask(module.module_azurerm_subnet["br1_fgt_priv"].subnet.address_prefix)
        port3subnetmask = cidrnetmask(module.module_azurerm_subnet["br1_fgt_pub2"].subnet.address_prefix)
        port4subnetmask = cidrnetmask(module.module_azurerm_subnet["br1_fgt_ha"].subnet.address_prefix)

        fgt_external_gw1 = cidrhost(module.module_azurerm_subnet["br1_fgt_pub1"].subnet.address_prefix, 1)
        fgt_external_gw2 = cidrhost(module.module_azurerm_subnet["br1_fgt_pub2"].subnet.address_prefix, 1)

        fgt_internal_gw = cidrhost(module.module_azurerm_subnet["br1_fgt_priv"].subnet.address_prefix, 1)
        fgt_mgmt_gw     = cidrhost(module.module_azurerm_subnet["br1_fgt_mgmt"].subnet.address_prefix, 1)

        isp2 = module.module_azurerm_network_interface["nic_br1_fortigate_2_3"].network_interface.name

        fgt_ha_peerip   = module.module_azurerm_network_interface["nic_br1_fortigate_1_4"].network_interface.private_ip_address
        fgt_ha_priority = "50"
        vnet_network    = module.module_azurerm_virtual_network["vnet_branch1"].virtual_network.address_space[0]

        port_ha   = "port4"
        port_mgmt = "port5"

        fgt_config_sdwan = true
        remotegw1        = module.module_azurerm_public_ip["pip_hub_elb_01"].public_ip.ip_address
        remotegw2        = module.module_azurerm_public_ip["pip_hub_elb_01"].public_ip.ip_address

        fgt_config_bgp = false
        fgt_as         = ""
        peer1          = ""
        peer2          = ""
        peer_as        = ""

        }
      )
    }
    "vm_br2_fgt_1" = {
      resource_group_name = local.resource_group_name
      location            = module.module_azurerm_virtual_network["vnet_branch2"].virtual_network.location

      name              = "${local.tag_project}-vm-br2-fgt-1"
      identity_identity = "SystemAssigned"

      availability_set_id = module.module_azurerm_availability_set["as_br2"].availability_set.id
      zones               = null

      delete_os_disk_on_termination    = true
      delete_data_disks_on_termination = true

      network_interface_ids        = [for nic in ["nic_br2_fortigate_1_1", "nic_br2_fortigate_1_2", "nic_br2_fortigate_1_3", "nic_br2_fortigate_1_4", "nic_br2_fortigate_1_5"] : module.module_azurerm_network_interface[nic].network_interface.id]
      primary_network_interface_id = module.module_azurerm_network_interface["nic_br2_fortigate_1_1"].network_interface.id

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
      boot_diagnostics_storage_uri = module.module_azurerm_storage_account["stbr2"].storage_account.primary_blob_endpoint

      storage_os_disk_name              = "${local.tag_project}-disk_os_br2_fgt_1"
      storage_os_disk_caching           = "ReadWrite"
      storage_os_disk_managed_disk_type = "Premium_LRS"
      storage_os_disk_create_option     = "FromImage"

      storage_data_disks = [
        {
          name              = "${local.tag_project}-disk_data_br2_fgt_1"
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
      config_data = templatefile("./assets/fgt-br-userdata.tpl", {
        fgt_id               = "vm-br2-fgt-1"
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
        gui_theme            = "neutrino"
        Port1IP              = module.module_azurerm_network_interface["nic_br2_fortigate_1_1"].network_interface.private_ip_address
        Port1Alias           = "isp1"
        Port2IP              = module.module_azurerm_network_interface["nic_br2_fortigate_1_2"].network_interface.private_ip_address
        Port2Alias           = "priv"
        Port3IP              = module.module_azurerm_network_interface["nic_br2_fortigate_1_3"].network_interface.private_ip_address
        Port3Alias           = "isp2"
        Port4IP              = module.module_azurerm_network_interface["nic_br2_fortigate_1_4"].network_interface.private_ip_address
        Port4Alias           = "ha"
        Port5Alias           = "mgmt"

        port1subnetmask = cidrnetmask(module.module_azurerm_subnet["br2_fgt_pub1"].subnet.address_prefix)
        port2subnetmask = cidrnetmask(module.module_azurerm_subnet["br2_fgt_priv"].subnet.address_prefix)
        port3subnetmask = cidrnetmask(module.module_azurerm_subnet["br2_fgt_pub2"].subnet.address_prefix)
        port4subnetmask = cidrnetmask(module.module_azurerm_subnet["br2_fgt_ha"].subnet.address_prefix)

        fgt_external_gw1 = cidrhost(module.module_azurerm_subnet["br2_fgt_pub1"].subnet.address_prefix, 1)
        fgt_external_gw2 = cidrhost(module.module_azurerm_subnet["br2_fgt_pub2"].subnet.address_prefix, 1)

        fgt_internal_gw = cidrhost(module.module_azurerm_subnet["br2_fgt_priv"].subnet.address_prefix, 1)
        fgt_mgmt_gw     = cidrhost(module.module_azurerm_subnet["br2_fgt_mgmt"].subnet.address_prefix, 1)

        isp2 = module.module_azurerm_network_interface["nic_br2_fortigate_1_3"].network_interface.name

        fgt_ha_peerip   = module.module_azurerm_network_interface["nic_br2_fortigate_2_4"].network_interface.private_ip_address
        fgt_ha_priority = "100"
        vnet_network    = module.module_azurerm_virtual_network["vnet_branch2"].virtual_network.address_space[0]

        port_ha   = "port4"
        port_mgmt = "port5"

        fgt_config_sdwan = true
        remotegw1        = module.module_azurerm_public_ip["pip_hub_elb_01"].public_ip.ip_address
        remotegw2        = module.module_azurerm_public_ip["pip_hub_elb_01"].public_ip.ip_address

        fgt_config_bgp = false
        fgt_as         = ""
        peer1          = ""
        peer2          = ""
        peer_as        = ""

        }
      )
    }
    "vm_br2_fgt_2" = {
      resource_group_name = local.resource_group_name
      location            = module.module_azurerm_virtual_network["vnet_branch2"].virtual_network.location

      name              = "${local.tag_project}-vm-br2-fgt-2"
      identity_identity = "SystemAssigned"

      availability_set_id = module.module_azurerm_availability_set["as_br2"].availability_set.id
      zones               = null

      delete_os_disk_on_termination    = true
      delete_data_disks_on_termination = true

      network_interface_ids        = [for nic in ["nic_br2_fortigate_2_1", "nic_br2_fortigate_2_2", "nic_br2_fortigate_2_3", "nic_br2_fortigate_2_4", "nic_br2_fortigate_2_5"] : module.module_azurerm_network_interface[nic].network_interface.id]
      primary_network_interface_id = module.module_azurerm_network_interface["nic_br2_fortigate_2_1"].network_interface.id

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
      boot_diagnostics_storage_uri = module.module_azurerm_storage_account["stbr2"].storage_account.primary_blob_endpoint

      storage_os_disk_name              = "${local.tag_project}-disk_os_br2_fgt_2"
      storage_os_disk_caching           = "ReadWrite"
      storage_os_disk_managed_disk_type = "Premium_LRS"
      storage_os_disk_create_option     = "FromImage"

      storage_data_disks = [
        {
          name              = "${local.tag_project}-disk_data_br2_fgt_2"
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
      config_data = templatefile("./assets/fgt-br-userdata.tpl", {
        fgt_id               = "vm-br2-fgt-2"
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
        gui_theme            = "neutrino"
        Port1IP              = module.module_azurerm_network_interface["nic_br2_fortigate_2_1"].network_interface.private_ip_address
        Port1Alias           = "isp1"
        Port2IP              = module.module_azurerm_network_interface["nic_br2_fortigate_2_2"].network_interface.private_ip_address
        Port2Alias           = "priv"
        Port3IP              = module.module_azurerm_network_interface["nic_br2_fortigate_2_3"].network_interface.private_ip_address
        Port3Alias           = "isp2"
        Port4IP              = module.module_azurerm_network_interface["nic_br2_fortigate_2_4"].network_interface.private_ip_address
        Port4Alias           = "ha"
        Port5Alias           = "mgmt"

        port1subnetmask = cidrnetmask(module.module_azurerm_subnet["br2_fgt_pub1"].subnet.address_prefix)
        port2subnetmask = cidrnetmask(module.module_azurerm_subnet["br2_fgt_priv"].subnet.address_prefix)
        port3subnetmask = cidrnetmask(module.module_azurerm_subnet["br2_fgt_pub2"].subnet.address_prefix)
        port4subnetmask = cidrnetmask(module.module_azurerm_subnet["br2_fgt_ha"].subnet.address_prefix)

        fgt_external_gw1 = cidrhost(module.module_azurerm_subnet["br2_fgt_pub1"].subnet.address_prefix, 1)
        fgt_external_gw2 = cidrhost(module.module_azurerm_subnet["br2_fgt_pub2"].subnet.address_prefix, 1)

        fgt_internal_gw = cidrhost(module.module_azurerm_subnet["br2_fgt_priv"].subnet.address_prefix, 1)
        fgt_mgmt_gw     = cidrhost(module.module_azurerm_subnet["br2_fgt_mgmt"].subnet.address_prefix, 1)

        isp2 = module.module_azurerm_network_interface["nic_br2_fortigate_2_3"].network_interface.name

        fgt_ha_peerip   = module.module_azurerm_network_interface["nic_br2_fortigate_1_4"].network_interface.private_ip_address
        fgt_ha_priority = "50"
        vnet_network    = module.module_azurerm_virtual_network["vnet_branch2"].virtual_network.address_space[0]

        port_ha   = "port4"
        port_mgmt = "port5"

        fgt_config_sdwan = true
        remotegw1        = module.module_azurerm_public_ip["pip_hub_elb_01"].public_ip.ip_address
        remotegw2        = module.module_azurerm_public_ip["pip_hub_elb_01"].public_ip.ip_address

        fgt_config_bgp = false
        fgt_as         = ""
        peer1          = ""
        peer2          = ""
        peer_as        = ""

        }
      )
    }
    "vm_br3_fgt_1" = {
      resource_group_name = local.resource_group_name
      location            = module.module_azurerm_virtual_network["vnet_branch3"].virtual_network.location

      name              = "${local.tag_project}-vm-br3-fgt-1"
      identity_identity = "SystemAssigned"

      availability_set_id = null
      zones               = null

      delete_os_disk_on_termination    = true
      delete_data_disks_on_termination = true

      network_interface_ids        = [for nic in ["nic_br3_fortigate_1_1", "nic_br3_fortigate_1_2", "nic_br3_fortigate_1_3"] : module.module_azurerm_network_interface[nic].network_interface.id]
      primary_network_interface_id = module.module_azurerm_network_interface["nic_br3_fortigate_1_1"].network_interface.id

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
      boot_diagnostics_storage_uri = module.module_azurerm_storage_account["stbr3"].storage_account.primary_blob_endpoint

      storage_os_disk_name              = "${local.tag_project}-disk_os_br3_fgt_1"
      storage_os_disk_caching           = "ReadWrite"
      storage_os_disk_managed_disk_type = "Premium_LRS"
      storage_os_disk_create_option     = "FromImage"

      storage_data_disks = [
        {
          name              = "${local.tag_project}-disk_data_br3_fgt_1"
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
      config_data = templatefile("./assets/fgt-br-userdata.tpl", {
        fgt_id               = "vm-br3-fgt-1"
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
        gui_theme            = "neutrino"
        Port1IP              = module.module_azurerm_network_interface["nic_br2_fortigate_1_1"].network_interface.private_ip_address
        Port1Alias           = "isp1"
        Port2IP              = module.module_azurerm_network_interface["nic_br2_fortigate_1_2"].network_interface.private_ip_address
        Port2Alias           = "priv"
        Port3IP              = module.module_azurerm_network_interface["nic_br2_fortigate_1_3"].network_interface.private_ip_address
        Port3Alias           = "isp2"
        Port4IP              = ""
        Port4Alias           = ""
        Port5Alias           = ""


        port1subnetmask = cidrnetmask(module.module_azurerm_subnet["br3_fgt_pub1"].subnet.address_prefix)
        port2subnetmask = cidrnetmask(module.module_azurerm_subnet["br3_fgt_priv"].subnet.address_prefix)
        port3subnetmask = cidrnetmask(module.module_azurerm_subnet["br3_fgt_pub2"].subnet.address_prefix)
        port4subnetmask = ""
        port5subnetmask = ""

        fgt_external_gw1 = cidrhost(module.module_azurerm_subnet["br3_fgt_pub1"].subnet.address_prefix, 1)
        fgt_external_gw2 = cidrhost(module.module_azurerm_subnet["br3_fgt_pub2"].subnet.address_prefix, 1)

        fgt_internal_gw = cidrhost(module.module_azurerm_subnet["br3_fgt_priv"].subnet.address_prefix, 1)
        fgt_mgmt_gw     = ""
        port_ha         = ""
        port_mgmt       = ""

        isp2 = module.module_azurerm_network_interface["nic_br2_fortigate_1_3"].network_interface.name

        fgt_ha_peerip   = ""
        fgt_ha_priority = ""

        vnet_network = module.module_azurerm_virtual_network["vnet_branch2"].virtual_network.address_space[0]

        fgt_config_sdwan = true
        remotegw1        = module.module_azurerm_public_ip["pip_hub_elb_01"].public_ip.ip_address
        remotegw2        = module.module_azurerm_public_ip["pip_hub_elb_01"].public_ip.ip_address

        fgt_config_bgp = false
        fgt_as         = ""
        peer1          = ""
        peer2          = ""
        peer_as        = ""

        }
      )
    }
  }

  branch_role_assignments = {
    "vm_br1_fgt_1" = {
      scope                = data.azurerm_resource_group.resource_group.id
      role_definition_name = "Reader"
      principal_id         = module.module_azurerm_virtual_machine["vm_br1_fgt_1"].virtual_machine.identity[0].principal_id
    }
    "vm_br1_fgt_2" = {
      scope                = data.azurerm_resource_group.resource_group.id
      role_definition_name = "Reader"
      principal_id         = module.module_azurerm_virtual_machine["vm_br1_fgt_2"].virtual_machine.identity[0].principal_id
    }
    "vm_br2_fgt_1" = {
      scope                = data.azurerm_resource_group.resource_group.id
      role_definition_name = "Reader"
      principal_id         = module.module_azurerm_virtual_machine["vm_br2_fgt_1"].virtual_machine.identity[0].principal_id
    }
    "vm_br2_fgt_2" = {
      scope                = data.azurerm_resource_group.resource_group.id
      role_definition_name = "Reader"
      principal_id         = module.module_azurerm_virtual_machine["vm_br2_fgt_2"].virtual_machine.identity[0].principal_id
    }
    "vm_br3_fgt_1" = {
      scope                = data.azurerm_resource_group.resource_group.id
      role_definition_name = "Reader"
      principal_id         = module.module_azurerm_virtual_machine["vm_br3_fgt_1"].virtual_machine.identity[0].principal_id
    }
  }
}