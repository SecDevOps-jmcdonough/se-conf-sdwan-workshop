locals {
  public_ips = {
    "hub_elb_pip1" = { name = "pip_hub_elb_01", allocation_method = "Static", sku = "Standard" }

    "pip_br1_elb_01" = { name = "pip_br1_elb_01", allocation_method = "Static", sku = "Standard" }
    "pip_br1_elb_02" = { name = "pip_br1_elb_02", allocation_method = "Static", sku = "Standard" }
    "pip_br2_elb_01" = { name = "pip_br2_elb_01", allocation_method = "Static", sku = "Standard" }
    "pip_br2_elb_02" = { name = "pip_br2_elb_02", allocation_method = "Static", sku = "Standard" }
    "pip_br3_01"     = { name = "pip_br3_01", allocation_method = "Static", sku = "Standard" }
    "pip_br3_02"     = { name = "pip_br3_02", allocation_method = "Static", sku = "Standard" }

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