locals {
  storage_accounts = {
    "sthub1" = {
      resource_group_name      = module.module_azurerm_resource_group.resource_group.name
      location                 = module.module_azurerm_virtual_network["vnet_hub1"].virtual_network.location
      name                     = format("%s%s", "sthub1", "${random_id.random_id.hex}")
      account_replication_type = "LRS"
      account_tier             = "Standard"
    }
    "stbr1" = {
      resource_group_name      = module.module_azurerm_resource_group.resource_group.name
      location                 = module.module_azurerm_virtual_network["vnet_branch1"].virtual_network.location
      name                     = format("%s%s", "stbr1", "${random_id.random_id.hex}")
      account_replication_type = "LRS"
      account_tier             = "Standard"
    }
    "stbr2" = {
      resource_group_name      = module.module_azurerm_resource_group.resource_group.name
      location                 = module.module_azurerm_virtual_network["vnet_branch2"].virtual_network.location
      name                     = format("%s%s", "stbr2", "${random_id.random_id.hex}")
      account_replication_type = "LRS"
      account_tier             = "Standard"
    }
    "stbr3" = {
      resource_group_name      = module.module_azurerm_resource_group.resource_group.name
      location                 = module.module_azurerm_virtual_network["vnet_branch3"].virtual_network.location
      name                     = format("%s%s", "stbr3", "${random_id.random_id.hex}")
      account_replication_type = "LRS"
      account_tier             = "Standard"
    }
    "stspk11" = {
      resource_group_name      = module.module_azurerm_resource_group.resource_group.name
      location                 = module.module_azurerm_virtual_network["vnet_spoke11"].virtual_network.location
      name                     = format("%s%s", "stspk11", "${random_id.random_id.hex}")
      account_replication_type = "LRS"
      account_tier             = "Standard"
    }
    "stspk12" = {
      resource_group_name      = module.module_azurerm_resource_group.resource_group.name
      location                 = module.module_azurerm_virtual_network["vnet_spoke11"].virtual_network.location
      name                     = format("%s%s", "stspk12", "${random_id.random_id.hex}")
      account_replication_type = "LRS"
      account_tier             = "Standard"
    }
  }
}

module "module_azurerm_storage_account" {
  for_each = local.storage_accounts

  source = "../azure/rm/azurerm_storage_account"

  resource_group_name = each.value.resource_group_name
  location            = each.value.location

  name                     = each.value.name
  account_replication_type = each.value.account_replication_type
  account_tier             = each.value.account_tier
}

resource "random_id" "random_id" {
  keepers = {
    resource_group_name = module.module_azurerm_resource_group.resource_group.name
  }

  byte_length = 8
}

output "storage_accounts" {
  value     = module.module_azurerm_storage_account[*]
  sensitive = true
}
