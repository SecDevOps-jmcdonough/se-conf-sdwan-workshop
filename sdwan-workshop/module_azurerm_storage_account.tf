locals {
  storage_accounts = {
    "sthub1" = {
      name                     = "sthub1"
      account_replication_type = "LRS"
      account_tier             = "Standard"
      vnet_name                = "vnet_hub1"
    }
    "stbr1" = {
      name                     = "stbr1"
      account_replication_type = "LRS"
      account_tier             = "Standard"
      vnet_name                = "vnet_branch1"
    }
    "stbr2" = {
      name                     = "stbr2"
      account_replication_type = "LRS"
      account_tier             = "Standard"
      vnet_name                = "vnet_branch2"
    }
    "stbr3" = {
      name                     = "stbr3"
      account_replication_type = "LRS"
      account_tier             = "Standard"
      vnet_name                = "vnet_branch3"
    }
    "stspk11" = {
      name                     = "stspk11"
      account_replication_type = "LRS"
      account_tier             = "Standard"
      vnet_name                = "vnet_spoke11"
    }
    "stspk12" = {
      name                     = "stspk12"
      account_replication_type = "LRS"
      account_tier             = "Standard"
      vnet_name                = "vnet_spoke12"
    }
  }
}

module "module_azurerm_storage_account" {
  for_each = local.storage_accounts

  source = "../azure/rm/azurerm_storage_account"

  resource_group_name      = module.module_azurerm_resource_group.resource_group.name
  location                 = module.module_azurerm_virtual_network[each.value.vnet_name].virtual_network.location
  name                     = format("%s%s", each.value.name, "${random_id.random_id.hex}")
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
