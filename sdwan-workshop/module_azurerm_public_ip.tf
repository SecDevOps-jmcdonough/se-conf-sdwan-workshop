locals {
  public_ips = {
    "hub_elb_pip1" = { name = "hub_elb_pip1", allocation_method = "Static", sku = "Standard" }

    "br1_elb_pip1" = { name = "br1_elb_pip1", allocation_method = "Static", sku = "Standard" }
    "br1_elb_pip2" = { name = "br1_elb_pip2", allocation_method = "Static", sku = "Standard" }
    "br2_elb_pip1" = { name = "br2_elb_pip1", allocation_method = "Static", sku = "Standard" }
    "br2_elb_pip2" = { name = "br2_elb_pip2", allocation_method = "Static", sku = "Standard" }
    "br3_pip1"     = { name = "br3_pip1", allocation_method = "Static", sku = "Standard" }
    "br3_pip2"     = { name = "br3_pip2", allocation_method = "Static", sku = "Standard" }

    "${local.tag_project}_ars_pip" = { name = "${local.tag_project}_ars_pip", allocation_method = "Static", sku = "Standard" }
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