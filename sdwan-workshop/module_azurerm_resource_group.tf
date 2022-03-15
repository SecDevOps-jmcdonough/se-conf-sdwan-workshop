locals {
  project_tag = "${var.username}-workshop-${var.TAG}"
  tag_project = "${var.TAG}-${var.username}-workshop"
  project     = "${var.username}-workshop"
  tag         = var.TAG

  resource_group_name = "${var.username}-workshop-${var.TAG}"
  location            = var.location

}

module "module_azurerm_resource_group" {

  source = "../azure/rm/azurerm_resource_group"

  name     = local.resource_group_name
  location = local.location
}

output "resource_group" {
  value = module.module_azurerm_resource_group
}
