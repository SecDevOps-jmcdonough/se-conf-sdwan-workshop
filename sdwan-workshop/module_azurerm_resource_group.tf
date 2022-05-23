locals {
  project_tag = "${var.username}-workshop-${var.tag}"
  tag_project = "${var.tag}-${var.username}-workshop"
  project     = "${var.username}-workshop"
  tag         = var.tag

  resource_group_name = "${var.username}-workshop-${var.tag}"
  location            = var.location
}

module "module_azurerm_resource_group" {

  source = "../azure/rm/azurerm_resource_group"

  name     = local.resource_group_name
  location = local.location
}

output "resource_group" {
  value = var.enable_module_output ? module.module_azurerm_resource_group : null
}
