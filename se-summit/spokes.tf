//############################ Create Spoke VNETs  ##################

resource "azurerm_virtual_network" "spokes" {
  for_each            = var.az_spokevnet
  name                = "${local.project}-${var.TAG}-${each.value.name}"
  location            = each.value.location
  resource_group_name = local.resource_group_hub_name
  address_space       = [each.value.cidr]

  tags = {
    Project = "${local.project}"
    Role    = "${var.TAG}"
  }
}

//############################ Create Spoke VNETs Subnets ############################

resource "azurerm_subnet" "spokesubnets" {
  for_each = var.az_spokevnetsubnet

  name                 = "${var.TAG}-${local.project}-${each.value.name}"
  resource_group_name  = local.resource_group_hub_name
  address_prefixes     = [each.value.cidr]
  virtual_network_name = azurerm_virtual_network.spokes[each.value.vnet].name

}


//############################ Peer the Hubs ##################

/*
///////Spokes to Hubs
resource "azurerm_virtual_network_peering" "spoke-to-hub" {
  for_each = var.az_spokevnet  
  
  name                      = "${local.project}-${var.TAG}-${each.value.name}-to-${each.value.peerto}"
  resource_group_name       = local.resource_group_hub_name
  virtual_network_name      = azurerm_virtual_network.spokes[each.key].name
  remote_virtual_network_id = azurerm_virtual_network.Hubs[each.value.peerto].id

  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
  use_remote_gateways          = true

    depends_on = [
    azurerm_resource_group_template_deployment.AzureRouteServer
  ]

}

/////// Hubs to spokes
resource "azurerm_virtual_network_peering" "hub-to-spoke" {
  for_each = var.az_spokevnet  
  
  name                      = "${local.project}-${var.TAG}-${each.value.peerto}-to-${each.value.name}"
  resource_group_name       = local.resource_group_hub_name
  virtual_network_name      = azurerm_virtual_network.Hubs[each.value.peerto].name
  remote_virtual_network_id = azurerm_virtual_network.spokes[each.key].id

  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
  allow_gateway_transit        = true

}

*/

//===================================Create Spoke Workloads===================================

data "template_file" "lnx_customdata" {
  template = "./assets/lnx-spoke.tpl"

  vars = {
  }
}
resource "azurerm_network_interface" "spokenics" {

  for_each = var.az_spokevnetsubnet

  name                = "${var.TAG}-${local.project}-${each.value.name}-lnx-nic"
  location            = azurerm_virtual_network.spokes[each.value.vnet].location
  resource_group_name = local.resource_group_hub_name

  enable_ip_forwarding          = false
  enable_accelerated_networking = false
  //network_security_group_id = "${azurerm_network_security_group.fgt_nsg.id}"
  ip_configuration {
    name                          = "ipconfig1"
    subnet_id                     = azurerm_subnet.spokesubnets[each.key].id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_virtual_machine" "spokelnx" {
  for_each = var.az_spokevnetsubnet

  name                = "${var.TAG}-${local.project}-${each.value.name}-lnx"
  location            = azurerm_virtual_network.spokes[each.value.vnet].location
  resource_group_name = local.resource_group_hub_name

  network_interface_ids = [azurerm_network_interface.spokenics[each.key].id]
  vm_size               = var.az_lnx_vmsize

  delete_os_disk_on_termination    = true
  delete_data_disks_on_termination = true

  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }

  storage_os_disk {
    name              = "${var.TAG}-${local.project}-${each.value.name}-lnx-OSDisk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  os_profile {
    computer_name  = "${var.TAG}-${local.project}-${each.value.name}-lnx"
    admin_username = var.username
    admin_password = var.password
    custom_data    = data.template_file.lnx_customdata.rendered
  }

  os_profile_linux_config {
    disable_password_authentication = false
  }

  tags = {
    Project = "${local.project}"
  }

}