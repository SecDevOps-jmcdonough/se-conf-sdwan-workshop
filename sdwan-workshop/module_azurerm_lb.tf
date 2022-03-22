locals {

  lbs = {
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
    "lb_branch1_ext_01" = {
      resource_group_name = module.module_azurerm_resource_group.resource_group.name
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
      resource_group_name = module.module_azurerm_resource_group.resource_group.name
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
      resource_group_name = module.module_azurerm_resource_group.resource_group.name
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
      resource_group_name = module.module_azurerm_resource_group.resource_group.name
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
}

module "module_azurerm_lb" {
  for_each = local.lbs

  source = "../azure/rm/azurerm_lb"

  resource_group_name        = each.value.resource_group_name
  location                   = each.value.location
  name                       = each.value.name
  sku                        = each.value.sku
  frontend_ip_configurations = each.value.frontend_ip_configurations

  tags = {
    Project = local.project
  }
}

output "lbs" {
  value = module.module_azurerm_lb[*]
}