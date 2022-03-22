locals {

  vm_linux_image = {
    "Canonical" = {
      publisher = "Canonical"
      offer     = "UbuntuServer"
      sku       = "18.04-LTS"
      version   = "latest"
    }
  }
  linux_virtual_machines = {
    "vm_br1_lnx_1" = {
      resource_group_name = module.module_azurerm_resource_group.resource_group.name
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
      resource_group_name = module.module_azurerm_resource_group.resource_group.name
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
      resource_group_name = module.module_azurerm_resource_group.resource_group.name
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
    "vm_spoke11_lnx_1" = {
      resource_group_name = module.module_azurerm_resource_group.resource_group.name
      location            = module.module_azurerm_virtual_network["vnet_spoke11"].virtual_network.location

      name = "${local.tag_project}-vm-spoke11-lnx-1"
      size = "Standard_D2_v3"

      availability_set_id   = null
      network_interface_ids = [for nic in ["nic_spoke11_lnx_1_1"] : module.module_azurerm_network_interface[nic].network_interface.id]

      admin_username = var.username
      admin_password = var.password
      computer_name  = "${local.tag_project}-vm-spoke11-lnx-1"

      disable_password_authentication = false

      os_disk_name                 = "${local.tag_project}-disk-spoke11-lnx-1-OS"
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

      tags = {
        Project = local.project
      }
    }
    "vm_spoke12_lnx_1" = {
      resource_group_name = module.module_azurerm_resource_group.resource_group.name
      location            = module.module_azurerm_virtual_network["vnet_spoke12"].virtual_network.location

      name = "${local.tag_project}-vm-spoke12-lnx-1"
      size = "Standard_D2_v3"

      availability_set_id   = null
      network_interface_ids = [for nic in ["nic_spoke12_lnx_1_1"] : module.module_azurerm_network_interface[nic].network_interface.id]

      admin_username = var.username
      admin_password = var.password
      computer_name  = "${local.tag_project}-vm-spoke12-lnx-1"

      disable_password_authentication = false

      os_disk_name                 = "${local.tag_project}-disk-spoke12-lnx-1-OS"
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

      tags = {
        Project = local.project
      }
    }
  }
}

module "module_azurerm_linux_virtual_machine" {
  for_each = local.linux_virtual_machines

  source = "../azure/rm/azurerm_linux_virtual_machine"

  resource_group_name = each.value.resource_group_name
  location            = each.value.location

  name = each.value.name
  size = each.value.size

  availability_set_id   = each.value.availability_set_id
  network_interface_ids = each.value.network_interface_ids

  admin_username = each.value.admin_username
  admin_password = each.value.admin_password
  computer_name  = each.value.computer_name
  custom_data    = each.value.custom_data

  disable_password_authentication = each.value.disable_password_authentication

  os_disk_name                 = each.value.os_disk_name
  os_disk_caching              = each.value.os_disk_caching
  os_disk_storage_account_type = each.value.os_disk_storage_account_type

  allow_extension_operations = each.value.allow_extension_operations

  storage_account_uri = each.value.storage_account_uri

  identity = each.value.identity

  source_image_reference_publisher = each.value.source_image_reference_publisher
  source_image_reference_offer     = each.value.source_image_reference_offer
  source_image_reference_sku       = each.value.source_image_reference_sku
  source_image_reference_version   = each.value.source_image_reference_version

  zone = each.value.zone

  tags = {
    Project = local.project
  }
}

output "virtual_linux_machines" {
  value     = module.module_azurerm_virtual_machine[*]
  sensitive = true
}