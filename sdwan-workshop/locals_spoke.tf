locals {
  spoke_virtual_networks = {
    "vnet_spoke11" = {
      resource_group_name = local.resource_group_name
      location            = "eastus"
      name                = "vnet_spoke11"
      address_space       = ["10.11.0.0/16"]
    }
    "vnet_spoke12" = {
      resource_group_name = local.resource_group_name
      location            = "eastus"
      name                = "vnet_spoke12"
      address_space       = ["10.12.0.0/16"]
    }
  }

  spoke_subnets = {
    "spoke11_subnet1" = {
      resource_group_name = local.resource_group_name
      name                = "spoke11_subnet1"
      address_prefixes    = [cidrsubnet(module.module_azurerm_virtual_network["vnet_spoke11"].virtual_network.address_space[0], 8, 0)]
      vnet_name           = "vnet_spoke11"
    }
    "spoke12_subnet1" = {
      resource_group_name = local.resource_group_name
      name                = "spoke12_subnet1"
      address_prefixes    = [cidrsubnet(module.module_azurerm_virtual_network["vnet_spoke12"].virtual_network.address_space[0], 8, 0)]
      vnet_name           = "vnet_spoke12"
    }
  }

  spoke_virtual_network_peerings = {
    # Spokes
    "spoke11_to_hub1" = {
      resource_group_name          = local.resource_group_name
      name                         = "spoke11_to_hub1"
      virtual_network_name         = "vnet_spoke11"
      remote_virtual_network_id    = module.module_azurerm_virtual_network["vnet_hub1"].virtual_network.id
      allow_virtual_network_access = true
      allow_forwarded_traffic      = true
      use_remote_gateways          = true
      allow_gateway_transit        = null
    }
    "spoke12_to_hub1" = {
      resource_group_name          = local.resource_group_name
      name                         = "spoke12_to_hub1"
      virtual_network_name         = "vnet_spoke12"
      remote_virtual_network_id    = module.module_azurerm_virtual_network["vnet_hub1"].virtual_network.id
      allow_virtual_network_access = true
      allow_forwarded_traffic      = true
      use_remote_gateways          = true
      allow_gateway_transit        = null
    }
  }

  spoke_network_interfaces = {
    # Spoke Linux VMs
    "nic_spoke11_lnx_1_1" = {
      resource_group_name           = local.resource_group_name
      name                          = "nic_spoke11_lnx_1_1"
      location                      = module.module_azurerm_virtual_network[module.module_azurerm_subnet["spoke11_subnet1"].subnet.virtual_network_name].virtual_network.location
      enable_ip_forwarding          = false
      enable_accelerated_networking = false

      ip_configurations = [
        {
          name                          = "ipconfig1"
          subnet_id                     = module.module_azurerm_subnet["spoke11_subnet1"].subnet.id
          private_ip_address_allocation = "Static"
          private_ip_address            = cidrhost(module.module_azurerm_subnet["spoke11_subnet1"].subnet.address_prefixes[0], 4)
          public_ip_address_id          = null
        }
      ]
    }
    "nic_spoke12_lnx_1_1" = {
      resource_group_name           = local.resource_group_name
      name                          = "nic_spoke12_lnx_1_1"
      location                      = module.module_azurerm_virtual_network[module.module_azurerm_subnet["spoke12_subnet1"].subnet.virtual_network_name].virtual_network.location
      enable_ip_forwarding          = false
      enable_accelerated_networking = false

      ip_configurations = [
        {
          name                          = "ipconfig1"
          subnet_id                     = module.module_azurerm_subnet["spoke12_subnet1"].subnet.id
          private_ip_address_allocation = "Static"
          private_ip_address            = cidrhost(module.module_azurerm_subnet["spoke12_subnet1"].subnet.address_prefixes[0], 4)
          public_ip_address_id          = null
        }
      ]
    }
  }

  spoke_storage_accounts = {
    "stspk11" = {
      resource_group_name      = local.resource_group_name
      location                 = module.module_azurerm_virtual_network["vnet_spoke11"].virtual_network.location
      name                     = format("%s%s", "stspk11", "${random_id.random_id.hex}")
      account_replication_type = "LRS"
      account_tier             = "Standard"
    }
    "stspk12" = {
      resource_group_name      = local.resource_group_name
      location                 = module.module_azurerm_virtual_network["vnet_spoke11"].virtual_network.location
      name                     = format("%s%s", "stspk12", "${random_id.random_id.hex}")
      account_replication_type = "LRS"
      account_tier             = "Standard"
    }
  }

  spoke_linux_virtual_machine_size = "Standard_D2_v3"
  spoke_linux_virtual_machines = {
    "vm_spoke11_lnx_1" = {
      resource_group_name = local.resource_group_name
      location            = module.module_azurerm_virtual_network["vnet_spoke11"].virtual_network.location

      name = "vm-spoke11-lnx-1"
      size = local.spoke_linux_virtual_machine_size

      availability_set_id   = null
      network_interface_ids = [for nic in ["nic_spoke11_lnx_1_1"] : module.module_azurerm_network_interface[nic].network_interface.id]

      admin_username = var.username
      admin_password = var.password
      computer_name  = "vm-spoke11-lnx-1"

      disable_password_authentication = false

      os_disk_name                 = "disk-spoke11-lnx-1-OS"
      os_disk_caching              = "ReadWrite"
      os_disk_storage_account_type = "Standard_LRS"

      allow_extension_operations = true

      storage_account_uri = module.module_azurerm_storage_account["stspk11"].storage_account.primary_blob_endpoint

      identity = "SystemAssigned"

      source_image_reference_publisher = local.vm_linux_image["Canonical"].publisher
      source_image_reference_offer     = local.vm_linux_image["Canonical"].offer
      source_image_reference_sku       = local.vm_linux_image["Canonical"].sku
      source_image_reference_version   = local.vm_linux_image["Canonical"].version

      custom_data = base64encode(templatefile("./assets/lnx-spoke.tpl", {}))

      zone = null

      tags = local.tags
    }

    "vm_spoke12_lnx_1" = {
      resource_group_name = local.resource_group_name
      location            = module.module_azurerm_virtual_network["vnet_spoke12"].virtual_network.location

      name = "vm-spoke12-lnx-1"
      size = local.spoke_linux_virtual_machine_size

      availability_set_id   = null
      network_interface_ids = [for nic in ["nic_spoke12_lnx_1_1"] : module.module_azurerm_network_interface[nic].network_interface.id]

      admin_username = var.username
      admin_password = var.password
      computer_name  = "vm-spoke12-lnx-1"

      disable_password_authentication = false

      os_disk_name                 = "disk-spoke12-lnx-1-OS"
      os_disk_caching              = "ReadWrite"
      os_disk_storage_account_type = "Standard_LRS"

      allow_extension_operations = true

      storage_account_uri = module.module_azurerm_storage_account["stspk12"].storage_account.primary_blob_endpoint

      identity = "SystemAssigned"

      source_image_reference_publisher = local.vm_linux_image["Canonical"].publisher
      source_image_reference_offer     = local.vm_linux_image["Canonical"].offer
      source_image_reference_sku       = local.vm_linux_image["Canonical"].sku
      source_image_reference_version   = local.vm_linux_image["Canonical"].version

      custom_data = base64encode(templatefile("./assets/lnx-spoke.tpl", {}))

      zone = null

      tags = local.tags
    }
  }
}