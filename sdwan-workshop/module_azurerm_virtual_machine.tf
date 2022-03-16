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
      name              = "vm-hub-fgt-1"
      identity_identity = "SystemAssigned"

      availability_set_id = module.module_azurerm_availability_set["as_hub"].availability_set.id
      #availability_set_id = null
      zones = null
      #zones = ["1"]

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

      storage_data_disk_name              = "disk_data_hub_fgt_1"
      storage_data_disk_managed_disk_type = "Premium_LRS"
      storage_data_disk_create_option     = "Empty"
      storage_data_disk_disk_size_gb      = "30"
      storage_data_disk_lun               = "0"

      # FortiGate Configuration
      config_template = "./assets/fgt-hub-userdata.tpl"
      gui_theme       = "jade"
      Port1IP         = module.module_azurerm_network_interface["nic_hub1_fortigate_1_1"].network_interface.private_ip_address
      Port1Alias      = "pub"
      Port2IP         = module.module_azurerm_network_interface["nic_hub1_fortigate_1_2"].network_interface.private_ip_address
      Port2Alias      = "priv"
      Port3IP         = module.module_azurerm_network_interface["nic_hub1_fortigate_1_3"].network_interface.private_ip_address
      Port3Alias      = "ha"
      Port4IP         = module.module_azurerm_network_interface["nic_hub1_fortigate_1_4"].network_interface.private_ip_address
      Port4Alias      = "mgmt"

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
    "vm_hub_fgt_2" = {
      name              = "vm-hub-fgt-2"
      identity_identity = "SystemAssigned"

      availability_set_id = module.module_azurerm_availability_set["as_hub"].availability_set.id
      #availability_set_id = null
      zones = null
      #zones = ["2"]

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

      storage_data_disk_name              = "disk_data_hub_fgt_2"
      storage_data_disk_managed_disk_type = "Premium_LRS"
      storage_data_disk_create_option     = "Empty"
      storage_data_disk_disk_size_gb      = "30"
      storage_data_disk_lun               = "0"

      # FortiGate Configuration
      config_template = "./assets/fgt-hub-userdata.tpl"
      gui_theme       = "jade"
      Port1IP         = module.module_azurerm_network_interface["nic_hub1_fortigate_2_1"].network_interface.private_ip_address
      Port1Alias      = "pub"
      Port2IP         = module.module_azurerm_network_interface["nic_hub1_fortigate_2_2"].network_interface.private_ip_address
      Port2Alias      = "priv"
      Port3IP         = module.module_azurerm_network_interface["nic_hub1_fortigate_2_3"].network_interface.private_ip_address
      Port3Alias      = "ha"
      Port4IP         = module.module_azurerm_network_interface["nic_hub1_fortigate_2_4"].network_interface.private_ip_address
      Port4Alias      = "mgmt"

      port3subnetmask = cidrnetmask(module.module_azurerm_subnet["hub1_fgt_ha"].subnet.address_prefix)
      port4subnetmask = cidrnetmask(module.module_azurerm_subnet["hub1_fgt_mgmt"].subnet.address_prefix)

      fgt_external_gw = cidrhost(module.module_azurerm_subnet["hub1_fgt_public"].subnet.address_prefix, 1)
      fgt_internal_gw = cidrhost(module.module_azurerm_subnet["hub1_fgt_private"].subnet.address_prefix, 1)
      fgt_mgmt_gw     = cidrhost(module.module_azurerm_subnet["hub1_fgt_mgmt"].subnet.address_prefix, 1)

      fgt_ha_peerip   = module.module_azurerm_network_interface["nic_hub1_fortigate_1_3"].network_interface.private_ip_address
      fgt_ha_priority = "50"
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
    /*"vm_br1_fgt_1" = {
      name              = "vm-br1-fgt-1"
      identity_identity = "SystemAssigned"

      availability_set_id = module.module_azurerm_availability_set["as_br1"].availability_set.id
      #availability_set_id = null
      zones = null
      #zones = ["1"]

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

      storage_os_disk_name              = "disk_os_br1_fgt_1"
      storage_os_disk_caching           = "ReadWrite"
      storage_os_disk_managed_disk_type = "Premium_LRS"
      storage_os_disk_create_option     = "FromImage"

      storage_data_disk_name              = "disk_data_br1_fgt_1"
      storage_data_disk_managed_disk_type = "Premium_LRS"
      storage_data_disk_create_option     = "Empty"
      storage_data_disk_disk_size_gb      = "30"
      storage_data_disk_lun               = "0"

      # FortiGate Configuration
      config_template = "./assets/fgt-br-userdata.tpl"
      gui_theme       = "nutrino"
      Port1IP         = module.module_azurerm_network_interface["nic_br1_fortigate_1_1"].network_interface.private_ip_address
      Port1Alias      = "isp1"
      Port2IP         = module.module_azurerm_network_interface["nic_br1_fortigate_1_2"].network_interface.private_ip_address
      Port2Alias      = "priv"
      Port3IP         = module.module_azurerm_network_interface["nic_br1_fortigate_1_3"].network_interface.private_ip_address
      Port3Alias      = "isp2"
      Port4IP         = module.module_azurerm_network_interface["nic_br1_fortigate_1_4"].network_interface.private_ip_address
      Port4Alias      = "ha"
      Port5Alias      = "mgmt"

      port1subnetmask = cidrnetmask(module.module_azurerm_subnet["br1_fgt_pub1"].subnet.address_prefix)
      port2subnetmask = cidrnetmask(module.module_azurerm_subnet["br1_fgt_priv"].subnet.address_prefix)
      port3subnetmask = cidrnetmask(module.module_azurerm_subnet["br1_fgt_pub2"].subnet.address_prefix)
      port4subnetmask = cidrnetmask(module.module_azurerm_subnet["br1_fgt_ha"].subnet.address_prefix)

      fgt_external_gw = cidrhost(module.module_azurerm_subnet["br1_fgt_pub1"].subnet.address_prefix, 1)
      fgt_internal_gw = cidrhost(module.module_azurerm_subnet["br1_fgt_priv"].subnet.address_prefix, 1)
      fgt_mgmt_gw     = cidrhost(module.module_azurerm_subnet["br1_fgt_mgmt"].subnet.address_prefix, 1)

      fgt_external_gw2 = cidrhost(module.module_azurerm_subnet["br1_fgt_pub2"].subnet.address_prefix, 1)
      isp2             = module.module_azurerm_network_interface["nic_br1_fortigate_1_3"].network_interface.name

      fgt_ha_peerip   = module.module_azurerm_network_interface["nic_br1_fortigate_2_4"].network_interface.private_ip_address
      fgt_ha_priority = "100"
      vnet_network    = module.module_azurerm_virtual_network["vnet_branch1"].virtual_network.address_space[0]

      port_ha   = "port4"
      port_mgmt = "port5"

      fgt_config_sdwan = true
      remotegw1        = module.module_azurerm_public_ip["pip_hub_elb_01"].public_ip.ip_address
      remotegw2        = module.module_azurerm_public_ip["pip_hub_elb_01"].public_ip.ip_address
    }*/
  }
}

module "module_azurerm_virtual_machine" {
  for_each = local.virtual_machines

  source = "../azure/rm/azurerm_virtual_machine"

  resource_group_name = module.module_azurerm_resource_group.resource_group.name
  location            = module.module_azurerm_resource_group.resource_group.location
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
  os_profile_custom_data    = data.template_file.vm[each.key].rendered


  storage_os_disk_name                = each.value.storage_os_disk_name
  storage_os_disk_caching             = each.value.storage_os_disk_caching
  storage_os_disk_managed_disk_type   = each.value.storage_os_disk_managed_disk_type
  storage_os_disk_create_option       = each.value.storage_os_disk_create_option
  storage_data_disk_name              = each.value.storage_data_disk_name
  storage_data_disk_managed_disk_type = each.value.storage_data_disk_managed_disk_type
  storage_data_disk_create_option     = each.value.storage_data_disk_create_option
  storage_data_disk_disk_size_gb      = each.value.storage_data_disk_disk_size_gb
  storage_data_disk_lun               = each.value.storage_data_disk_lun

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

data "template_file" "vm" {
  for_each = local.virtual_machines

  template = file(each.value.config_template)
  vars = {
    fgt_id               = each.value.name
    fgt_license_file     = ""
    fgt_username         = var.username
    fgt_config_ha        = true
    fgt_config_autoscale = false
    fgt_ssh_public_key   = ""
    fgt_config_probe     = true
    gui_theme            = each.value.gui_theme

    Port1IP    = each.value.Port1IP
    Port1Alias = each.value.Port1Alias
    Port2IP    = each.value.Port2IP
    Port2Alias = each.value.Port2Alias
    Port3IP    = each.value.Port3IP
    Port3Alias = each.value.Port3Alias
    Port4IP    = each.value.Port4IP
    Port4Alias = each.value.Port4Alias

    port3subnetmask = each.value.port3subnetmask
    port4subnetmask = each.value.port4subnetmask

    fgt_external_gw = each.value.fgt_external_gw
    fgt_internal_gw = each.value.fgt_internal_gw
    fgt_mgmt_gw     = each.value.fgt_mgmt_gw

    fgt_ha_peerip   = each.value.fgt_ha_peerip
    fgt_ha_priority = each.value.fgt_ha_priority
    vnet_network    = each.value.vnet_network

    port_ha   = each.value.port_ha
    port_mgmt = each.value.port_mgmt

    fgt_config_bgp = each.value.fgt_config_bgp
    fgt_as         = each.value.fgt_as
    peer1          = each.value.peer1
    peer2          = each.value.peer2
    peer_as        = each.value.peer_as

    fgt_config_sdwan = each.value.fgt_config_sdwan
  }
}

output "virtual_machines" {
  value     = module.module_azurerm_virtual_machine[*]
  sensitive = true
}