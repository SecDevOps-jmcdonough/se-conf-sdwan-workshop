locals {
  public_ips = {
    # Hub 1
    "pip_hub_elb_01" = { name = "pip_hub_elb_01", allocation_method = "Static", sku = "Standard" }

    # Branch 1
    "pip_br1_elb_01" = { name = "pip_br1_elb_01", allocation_method = "Static", sku = "Standard" }
    "pip_br1_elb_02" = { name = "pip_br1_elb_02", allocation_method = "Static", sku = "Standard" }

    # Branch 2
    "pip_br2_elb_01" = { name = "pip_br2_elb_01", allocation_method = "Static", sku = "Standard" }
    "pip_br2_elb_02" = { name = "pip_br2_elb_02", allocation_method = "Static", sku = "Standard" }

    # Branch 3
    "pip_br3_01" = { name = "pip_br3_01", allocation_method = "Static", sku = "Standard" }
    "pip_br3_02" = { name = "pip_br3_02", allocation_method = "Static", sku = "Standard" }

    # Azure Route Server
    "pip_${local.tag_project}_ars" = { name = "pip_${local.tag_project}_ars_pip", allocation_method = "Static", sku = "Standard" }
  }
}

module "module_azurerm_public_ip" {
  for_each = local.public_ips

  source = "../azure/rm/azurerm_public_ip"

  resource_group_name = module.module_azurerm_resource_group.resource_group.name
  location            = module.module_azurerm_resource_group.resource_group.location
  name                = each.value.name
  allocation_method   = each.value.allocation_method
  sku                 = each.value.sku

  tags = {
    Project = local.project
  }
}

output "public_ips" {
  value = module.module_azurerm_public_ip[*]
}