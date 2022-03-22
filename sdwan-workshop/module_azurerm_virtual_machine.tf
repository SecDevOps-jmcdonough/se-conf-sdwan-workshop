locals {

  vm_image = {
    "Canonical" = {
      publisher = "Canonical"
      offer     = "UbuntuServer"
      sku       = "18.04-LTS"
      version   = "latest"
    }
    "fortinet" = {
      publisher = "fortinet"
      offer     = "fortinet_fortigate-vm_v5"
      sku       = "fortinet_fg-vm_payg_20190624"
      version   = "7.0.5"
    }
  }

  virtual_machines = {
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
    "vm_br1_fgt_1" = {
      resource_group_name = module.module_azurerm_resource_group.resource_group.name
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
      resource_group_name = module.module_azurerm_resource_group.resource_group.name
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
      resource_group_name = module.module_azurerm_resource_group.resource_group.name
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
      resource_group_name = module.module_azurerm_resource_group.resource_group.name
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
      resource_group_name = module.module_azurerm_resource_group.resource_group.name
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
}

module "module_azurerm_virtual_machine" {
  for_each = local.virtual_machines

  source = "../azure/rm/azurerm_virtual_machine"

  resource_group_name = each.value.resource_group_name
  location            = each.value.location
  name                = each.value.name

  availability_set_id = each.value.availability_set_id

  network_interface_ids        = each.value.network_interface_ids
  primary_network_interface_id = each.value.primary_network_interface_id

  vm_size = each.value.vm_size

  delete_os_disk_on_termination    = each.value.delete_os_disk_on_termination
  delete_data_disks_on_termination = each.value.delete_data_disks_on_termination

  identity_identity = each.value.identity_identity

  storage_image_reference_publisher = each.value.storage_image_reference_publisher
  storage_image_reference_offer     = each.value.storage_image_reference_offer
  storage_image_reference_sku       = each.value.storage_image_reference_sku
  storage_image_reference_version   = each.value.storage_image_reference_version

  plan_name      = each.value.plan_name
  plan_publisher = each.value.plan_publisher
  plan_product   = each.value.plan_product

  os_profile_computer_name  = each.value.name
  os_profile_admin_username = each.value.os_profile_admin_username
  os_profile_admin_password = each.value.os_profile_admin_password
  os_profile_custom_data    = each.value.config_data


  storage_os_disk_name              = each.value.storage_os_disk_name
  storage_os_disk_caching           = each.value.storage_os_disk_caching
  storage_os_disk_managed_disk_type = each.value.storage_os_disk_managed_disk_type
  storage_os_disk_create_option     = each.value.storage_os_disk_create_option

  storage_data_disks = each.value.storage_data_disks

  os_profile_linux_config_disable_password_authentication = each.value.os_profile_linux_config_disable_password_authentication

  boot_diagnostics_enabled     = each.value.boot_diagnostics_enabled
  boot_diagnostics_storage_uri = each.value.boot_diagnostics_storage_uri

  zones = each.value.zones

  tags = {
    Project = local.project
  }
}

resource "random_string" "random_string" {
  length  = 30
  special = false
}

output "virtual_machines" {
  value     = module.module_azurerm_virtual_machine[*]
  sensitive = true
}