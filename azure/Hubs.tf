//############################ Create Resource Group ##################

resource "azurerm_resource_group" "hubrg" {
  name     = "${var.project}-${var.TAG}"
  location = var.hubrglocation
}


//############################ Create Hub VNETs  ##################

resource "azurerm_virtual_network" "Hubs" {
  for_each            = var.az_hubs
  name                = "${var.project}-${var.TAG}-${each.value.name}"
  location            = each.value.location
  resource_group_name = azurerm_resource_group.hubrg.name
  address_space       = [each.value.cidr]

  tags = {
    Project = "${var.project}"
    Role    = "${var.TAG}"
  }
}

//############################ Create Hub Subnets ############################

resource "azurerm_subnet" "hubsubnets" {
  for_each = var.az_hubsubnetscidrs

  name                 = each.value.name == "RouteServerSubnet" ? "${each.value.name}" : "${var.TAG}-${var.project}-subnet-${each.value.name}"
  resource_group_name  = azurerm_resource_group.hubrg.name
  address_prefixes     = [each.value.cidr]
  virtual_network_name = azurerm_virtual_network.Hubs[each.value.vnet].name

}

//############################  Hub Route Tables ############################
resource "azurerm_route_table" "hubvnet_route_tables" {
  for_each = var.vnetroutetables

  name                = "${var.TAG}-${var.project}-${each.value.name}"
  location            = azurerm_virtual_network.Hubs[each.value.vnet].location
  resource_group_name = azurerm_resource_group.hubrg.name
  //disable_bgp_route_propagation = false
  tags = {
    Project = "${var.project}"
  }
}

//############################  RT Associations ############################
resource "azurerm_subnet_route_table_association" "vnet_rt_assoc" {
  for_each = var.vnetroutetables

  subnet_id = azurerm_subnet.hubsubnets[each.key].id
  #subnet_id      = data.azurerm_subnet.pub_subnet.id
  route_table_id = azurerm_route_table.hubvnet_route_tables[each.key].id
}

//############################  FGTs NICs ############################


resource "azurerm_network_interface" "hub1fgt1nics" {
  for_each                      = var.hub1fgt1
  name                          = "${each.value.vnet}-${each.value.vmname}-${each.value.name}"
  location                      = azurerm_virtual_network.Hubs[each.value.vnet].location
  resource_group_name           = azurerm_resource_group.hubrg.name
  enable_ip_forwarding          = true
  enable_accelerated_networking = true

  ip_configuration {
    name      = "ipconfig1"
    subnet_id = azurerm_subnet.hubsubnets[each.value.subnet].id
    #subnet_id                     = data.azurerm_subnet.dut1subnetid[each.key].id
    private_ip_address_allocation = "static"
    private_ip_address            = each.value.ip
    //public_ip_address_id          = (each.value.name == "port1" ? azurerm_public_ip.fgt1pip1.id : null)
  }
}



resource "azurerm_network_interface" "hub1fgt2nics" {
  for_each                      = var.hub1fgt2
  name                          = "${each.value.vnet}-${each.value.vmname}-${each.value.name}"
  location                      = azurerm_virtual_network.Hubs[each.value.vnet].location
  resource_group_name           = azurerm_resource_group.hubrg.name
  enable_ip_forwarding          = true
  enable_accelerated_networking = false

  ip_configuration {
    name      = "ipconfig1"
    subnet_id = azurerm_subnet.hubsubnets[each.value.subnet].id
    #subnet_id                     = data.azurerm_subnet.dut1subnetid[each.key].id
    private_ip_address_allocation = "static"
    private_ip_address            = each.value.ip
    //public_ip_address_id          = (each.value.name == "port1" ? azurerm_public_ip.fgt2pip1.id : null)
  }
}



resource "azurerm_network_interface" "hub1fgt3nics" {
  for_each                      = var.hub1fgt3
  name                          = "${each.value.vnet}-${each.value.vmname}-${each.value.name}"
  location                      = azurerm_virtual_network.Hubs[each.value.vnet].location
  resource_group_name           = azurerm_resource_group.hubrg.name
  enable_ip_forwarding          = true
  enable_accelerated_networking = false

  ip_configuration {
    name      = "ipconfig1"
    subnet_id = azurerm_subnet.hubsubnets[each.value.subnet].id
    #subnet_id                     = data.azurerm_subnet.dut1subnetid[each.key].id
    private_ip_address_allocation = "static"
    private_ip_address            = each.value.ip
    //public_ip_address_id          = (each.value.name == "port1" ? azurerm_public_ip.fgt3pip1.id : null)
  }
}




//############################  FGT NSGs ##################

resource "azurerm_network_security_group" "fgt_nsgs" {
  for_each = var.nsgs

  name                = "${var.TAG}-${var.project}-${each.value.vnet}-${each.value.name}"
  location            = azurerm_virtual_network.Hubs[each.value.vnet].location
  resource_group_name = azurerm_resource_group.hubrg.name
}

resource "azurerm_network_security_rule" "fgt_nsg_rules" {
  for_each = var.nsgrules

  name                        = each.value.rulename
  resource_group_name         = azurerm_resource_group.hubrg.name
  network_security_group_name = azurerm_network_security_group.fgt_nsgs[each.value.nsgname].name
  priority                    = each.value.priority
  direction                   = each.value.direction
  access                      = each.value.access
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"

}

//############################ NIC to NSG  ############################


resource "azurerm_network_interface_security_group_association" "hub1fgt1nsg" {
  for_each                  = var.hub1fgt1
  network_interface_id      = azurerm_network_interface.hub1fgt1nics[each.key].id
  network_security_group_id = azurerm_network_security_group.fgt_nsgs[each.value.nsgname].id
}

resource "azurerm_network_interface_security_group_association" "hub1fgt2nsg" {
  for_each                  = var.hub1fgt1
  network_interface_id      = azurerm_network_interface.hub1fgt2nics[each.key].id
  network_security_group_id = azurerm_network_security_group.fgt_nsgs[each.value.nsgname].id
}

resource "azurerm_network_interface_security_group_association" "hub1fgt3nsg" {
  for_each                  = var.hub1fgt1
  network_interface_id      = azurerm_network_interface.hub1fgt3nics[each.key].id
  network_security_group_id = azurerm_network_security_group.fgt_nsgs[each.value.nsgname].id
}


//////////////////////////HUB1 FGT1//////////////////////////
data "template_file" "hub1fgt1_customdata" {
  template = file("./assets/fgt-aa-userdata.tpl")
  vars = {
    fgt_id               = "hub1-fgt1"
    fgt_license_file     = ""
    fgt_username         = var.username
    fgt_config_ha        = false
    fgt_config_autoscale = false
    fgt_ssh_public_key   = ""
    fgt_config_probe     = true
    fgt_config_bgp       = true
    fgt_as               = var.az_fgtasn
    peer1                = cidrhost(element(azurerm_subnet.hubsubnets["hub1_RouteServer"].address_prefixes, 0), 4)
    peer2                = cidrhost(element(azurerm_subnet.hubsubnets["hub1_RouteServer"].address_prefixes, 0), 5)
    peer_as              = "65515"
    #role               = "primary"
    #sync-port          = 

    //Port1IP = var.hub1fgt3["nic1"]["ip"]
    //Port2IP = var.hub1fgt3["nic2"]["ip"]

    //public_subnet_mask  = cidrnetmask(var.az_hubsubnetscidrs["hub1_fgt_public"]["cidr"])
    //private_subnet_mask = cidrnetmask(var.az_hubsubnetscidrs["hub1_fgt_private"]["cidr"])

    fgt_port1_gw = cidrhost(element(azurerm_subnet.hubsubnets["hub1_fgt_public"].address_prefixes, 0), 1)
    fgt_port2_gw = cidrhost(element(azurerm_subnet.hubsubnets["hub1_fgt_private"].address_prefixes, 0), 1)
  }
}

resource "azurerm_virtual_machine" "hub1fgt1" {
  name                         = "${var.TAG}-${var.project}-hub1-fgt1"
  location                     = azurerm_virtual_network.Hubs["hub1"].location
  resource_group_name          = azurerm_resource_group.hubrg.name
  network_interface_ids        = [for nic in azurerm_network_interface.hub1fgt1nics : nic.id]
  primary_network_interface_id = element(values(azurerm_network_interface.hub1fgt1nics)[*].id, 0)
  vm_size                      = var.az_fgt_vmsize

  identity {
    type = "SystemAssigned"
  }

  storage_image_reference {
    publisher = "fortinet"
    offer     = var.az_FGT_OFFER
    sku       = var.az_FGT_IMAGE_SKU
    version   = var.az_FGT_VERSION
  }

  plan {
    publisher = "fortinet"
    product   = var.az_FGT_OFFER
    name      = var.az_FGT_IMAGE_SKU
  }

  storage_os_disk {
    name              = "${var.TAG}-${var.project}-hub1-fgt1_OSDisk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  storage_data_disk {
    name              = "${var.TAG}-${var.project}-hub1-fgt1_DataDisk"
    managed_disk_type = "Premium_LRS"
    create_option     = "Empty"
    lun               = 0
    disk_size_gb      = "20"
  }
  os_profile {
    computer_name  = "${var.TAG}-${var.project}-hub1-fgt1"
    admin_username = var.username
    admin_password = var.password
    custom_data    = data.template_file.hub1fgt1_customdata.rendered
  }

  os_profile_linux_config {
    disable_password_authentication = false
  }

  tags = {
    Project = "${var.project}"
  }

}
///////////////IAM////////////////
resource "azurerm_role_assignment" "hub1fgt1_reader" {
  scope                = azurerm_resource_group.hubrg.id
  role_definition_name = "Reader"
  principal_id         = azurerm_virtual_machine.hub1fgt1.identity[0].principal_id
  depends_on = [
    azurerm_virtual_machine.hub1fgt1
  ]
}

//////////////////////////HUB1 FGT2//////////////////////////
data "template_file" "hub1fgt2_customdata" {
  template = file("./assets/fgt-aa-userdata.tpl")
  vars = {
    fgt_id               = "hub1-fgt2"
    fgt_license_file     = ""
    fgt_username         = var.username
    fgt_config_ha        = false
    fgt_config_autoscale = false
    fgt_ssh_public_key   = ""
    fgt_config_probe     = true
    fgt_config_bgp       = true
    fgt_as               = var.az_fgtasn
    peer1                = cidrhost(element(azurerm_subnet.hubsubnets["hub1_RouteServer"].address_prefixes, 0), 4)
    peer2                = cidrhost(element(azurerm_subnet.hubsubnets["hub1_RouteServer"].address_prefixes, 0), 5)
    peer_as              = "65515"
    #role               = "primary"
    #sync-port          = 

    //Port1IP = var.hub1fgt3["nic1"]["ip"]
    //Port2IP = var.hub1fgt3["nic2"]["ip"]

    //public_subnet_mask  = cidrnetmask(var.az_hubsubnetscidrs["hub1_fgt_public"]["cidr"])
    //private_subnet_mask = cidrnetmask(var.az_hubsubnetscidrs["hub1_fgt_private"]["cidr"])

    fgt_port1_gw = cidrhost(element(azurerm_subnet.hubsubnets["hub1_fgt_public"].address_prefixes, 0), 1)
    fgt_port2_gw = cidrhost(element(azurerm_subnet.hubsubnets["hub1_fgt_private"].address_prefixes, 0), 1)

  }
}

resource "azurerm_virtual_machine" "hub1fgt2" {
  name                         = "${var.TAG}-${var.project}-hub1-fgt2"
  location                     = azurerm_virtual_network.Hubs["hub1"].location
  resource_group_name          = azurerm_resource_group.hubrg.name
  network_interface_ids        = [for nic in azurerm_network_interface.hub1fgt2nics : nic.id]
  primary_network_interface_id = element(values(azurerm_network_interface.hub1fgt2nics)[*].id, 0)
  vm_size                      = var.az_fgt_vmsize

  identity {
    type = "SystemAssigned"
  }

  storage_image_reference {
    publisher = "fortinet"
    offer     = var.az_FGT_OFFER
    sku       = var.az_FGT_IMAGE_SKU
    version   = var.az_FGT_VERSION
  }

  plan {
    publisher = "fortinet"
    product   = var.az_FGT_OFFER
    name      = var.az_FGT_IMAGE_SKU
  }

  storage_os_disk {
    name              = "${var.TAG}-${var.project}-hub1-fgt2_OSDisk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  storage_data_disk {
    name              = "${var.TAG}-${var.project}-hub1-fgt2_DataDisk"
    managed_disk_type = "Premium_LRS"
    create_option     = "Empty"
    lun               = 0
    disk_size_gb      = "20"
  }
  os_profile {
    computer_name  = "${var.TAG}-${var.project}-hub1-fgt2"
    admin_username = var.username
    admin_password = var.password
    custom_data    = data.template_file.hub1fgt2_customdata.rendered
  }

  os_profile_linux_config {
    disable_password_authentication = false
  }

  tags = {
    Project = "${var.project}"
  }

}
///////////////IAM////////////////
resource "azurerm_role_assignment" "hub1fgt2_reader" {
  scope                = azurerm_resource_group.hubrg.id
  role_definition_name = "Reader"
  principal_id         = azurerm_virtual_machine.hub1fgt2.identity[0].principal_id
  depends_on = [
    azurerm_virtual_machine.hub1fgt2
  ]
}

//////////////////////////HUB1 FGT3//////////////////////////
data "template_file" "hub1fgt3_customdata" {
  template = file("./assets/fgt-aa-userdata.tpl")
  vars = {
    fgt_id               = "hub1-fgt3"
    fgt_license_file     = ""
    fgt_username         = var.username
    fgt_config_ha        = false
    fgt_config_autoscale = false
    fgt_ssh_public_key   = ""
    fgt_config_probe     = true
    fgt_config_bgp       = true
    fgt_as               = var.az_fgtasn
    peer1                = cidrhost(element(azurerm_subnet.hubsubnets["hub1_RouteServer"].address_prefixes, 0), 4)
    peer2                = cidrhost(element(azurerm_subnet.hubsubnets["hub1_RouteServer"].address_prefixes, 0), 5)
    peer_as              = "65515"
    #role               = "primary"
    #sync-port          = 

    //Port1IP = var.hub1fgt3["nic1"]["ip"]
    //Port2IP = var.hub1fgt3["nic2"]["ip"]

    //public_subnet_mask  = cidrnetmask(var.az_hubsubnetscidrs["hub1_fgt_public"]["cidr"])
    //private_subnet_mask = cidrnetmask(var.az_hubsubnetscidrs["hub1_fgt_private"]["cidr"])

    fgt_port1_gw = cidrhost(element(azurerm_subnet.hubsubnets["hub1_fgt_public"].address_prefixes, 0), 1)
    fgt_port2_gw = cidrhost(element(azurerm_subnet.hubsubnets["hub1_fgt_private"].address_prefixes, 0), 1)

  }
}
resource "azurerm_virtual_machine" "hub1fgt3" {
  name                         = "${var.TAG}-${var.project}-hub1-fgt3"
  location                     = azurerm_virtual_network.Hubs["hub1"].location
  resource_group_name          = azurerm_resource_group.hubrg.name
  network_interface_ids        = [for nic in azurerm_network_interface.hub1fgt3nics : nic.id]
  primary_network_interface_id = element(values(azurerm_network_interface.hub1fgt3nics)[*].id, 0)
  vm_size                      = var.az_fgt_vmsize

  identity {
    type = "SystemAssigned"
  }

  storage_image_reference {
    publisher = "fortinet"
    offer     = var.az_FGT_OFFER
    sku       = var.az_FGT_IMAGE_SKU
    version   = var.az_FGT_VERSION
  }

  plan {
    publisher = "fortinet"
    product   = var.az_FGT_OFFER
    name      = var.az_FGT_IMAGE_SKU
  }

  storage_os_disk {
    name              = "${var.TAG}-${var.project}-hub1-fgt3_OSDisk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  storage_data_disk {
    name              = "${var.TAG}-${var.project}-hub1-fgt3_DataDisk"
    managed_disk_type = "Premium_LRS"
    create_option     = "Empty"
    lun               = 0
    disk_size_gb      = "20"
  }
  os_profile {
    computer_name  = "${var.TAG}-${var.project}-hub1-fgt3"
    admin_username = var.username
    admin_password = var.password
    custom_data    = data.template_file.hub1fgt3_customdata.rendered
  }

  os_profile_linux_config {
    disable_password_authentication = false
  }

  tags = {
    Project = "${var.project}"
  }

}
///////////////IAM////////////////
resource "azurerm_role_assignment" "hub1fgt3_reader" {
  scope                = azurerm_resource_group.hubrg.id
  role_definition_name = "Reader"
  principal_id         = azurerm_virtual_machine.hub1fgt3.identity[0].principal_id
  depends_on = [
    azurerm_virtual_machine.hub1fgt3
  ]
}

//////////////////////////////////LB and NAT rules//////////////////////////////////////

resource "azurerm_public_ip" "hubpip" {
  for_each            = var.hubpublicip
  name                = "${var.TAG}-${var.project}-${each.value.name}"
  location            = azurerm_virtual_network.Hubs[each.value.vnet].location
  resource_group_name = azurerm_resource_group.hubrg.name
  allocation_method   = "Static"
  sku                 = "Standard"

  tags = {
    Project = "${var.project}"
  }

}

resource "azurerm_lb" "hub1extlb" {
  for_each            = var.hubextlb
  name                = "${var.TAG}-${var.project}-${each.value.name}"
  location            = azurerm_virtual_network.Hubs[each.value.vnet].location
  resource_group_name = azurerm_resource_group.hubrg.name
  sku                 = "Standard"

  frontend_ip_configuration {
    name                 = each.value.frontendip
    public_ip_address_id = (each.value.type == "external" ? azurerm_public_ip.hubpip[each.value.frontendip].id : null)

  }
  tags = {
    Project = "${var.project}"
  }
}


resource "azurerm_lb_nat_rule" "fgttfaccess" {
  for_each = var.hubextlbnat

  resource_group_name            = azurerm_resource_group.hubrg.name
  loadbalancer_id                = azurerm_lb.hub1extlb[each.value.lb].id
  name                           = each.value.name
  protocol                       = each.value.protocol
  frontend_port                  = each.value.frontport
  backend_port                   = each.value.backport
  frontend_ip_configuration_name = each.value.frontendip
}

resource "azurerm_network_interface_nat_rule_association" "fgtmastertfaccess" {
  for_each = var.hubextlbnat

  network_interface_id  = (each.value.interfacenat == "fgt1-port1" ? azurerm_network_interface.hub1fgt1nics["nic1"].id : (each.value.interfacenat == "fgt2-port1" ? azurerm_network_interface.hub1fgt2nics["nic1"].id : azurerm_network_interface.hub1fgt3nics["nic1"].id))
  ip_configuration_name = "ipconfig1"
  nat_rule_id           = azurerm_lb_nat_rule.fgttfaccess[each.key].id
}


//////////////////////////////////Azure Route Server////////////////////////////////////


resource "azurerm_public_ip" "arspip" {
  name                = "${var.TAG}-${var.project}-arspip"
  location            = azurerm_virtual_network.Hubs["hub1"].location
  resource_group_name = azurerm_resource_group.hubrg.name
  allocation_method   = "Static"
  sku                 = "Standard"

  tags = {
    Project = "${var.project}"
  }

}

resource "azurerm_resource_group_template_deployment" "AzureRouteServer" {

  lifecycle {
    ignore_changes = all
  }

  name                = "SDWAN-WOrkshop-ARS"
  resource_group_name = azurerm_resource_group.hubrg.name
  deployment_mode     = "Incremental"
  debug_level         = "requestContent, responseContent"
  parameters_content = jsonencode({
    "project" = {
      value = var.project
    },
    "TAG" = {
      value = var.TAG
    },
    "location" = {
      value = azurerm_virtual_network.Hubs["hub1"].location
    },
    "RouteServerSubnetID" = {
      value = azurerm_subnet.hubsubnets["hub1_RouteServer"].id
    },
    "peer1ip" = {
      value = azurerm_network_interface.hub1fgt1nics["nic2"].private_ip_address
    },
    "peer2ip" = {
      value = azurerm_network_interface.hub1fgt2nics["nic2"].private_ip_address
    },
    "peer3ip" = {
      value = azurerm_network_interface.hub1fgt3nics["nic2"].private_ip_address
    },
    "peerasn" = {
      value = var.az_fgtasn
    },
    "RouteServerPIPID" = {
      value = azurerm_public_ip.arspip.id
    }
  })
  template_content = <<TEMPLATE
  {
    "$schema": "https://schema.management.azure.com/schemas/2015-01-01/deploymentTemplate.json#",
    "contentVersion": "1.0.0.0",
    "parameters": {
        "project": {
            "type": "string",
            "metadata": {
                "description": "Project name"
            }
        },
        "TAG": {
            "type": "string",
            "metadata": {
                "description": "Prefix"
            }
        },
        "location": {
            "type": "string",
            "metadata": {
                "description": "Resource location"
            }
        },
        "RouteServerSubnetID": {
            "type": "string",
            "metadata": {
                "description": "RouteServerSubnet ID"
            }
        },
        "peer1ip": {
            "type": "string",
            "metadata": {
                "description": "Peer1 IP"
            }
        },
        "peer2ip": {
            "type": "string",
            "metadata": {
                "description": "Peer2 IP"
            }
        },
        "peer3ip": {
            "type": "string",
            "metadata": {
                "description": "Peer3 IP"
            }
        },
        "peerasn": {
            "type": "string",
            "metadata": {
                "description": "Peer ASN"
            }
        },
        "RouteServerPIPID": {
            "type": "string",
            "metadata": {
                "description": "RouteServerPIP ID"
              }
        }   
    },
    "variables": {
        "fgRouteServerName": "[concat(parameters('project'),'-',parameters('TAG'),'-RouteServer')]",
        "ARSpeer1": "[concat(parameters('TAG'),'-fgt1')]",
        "ARSpeer2": "[concat(parameters('TAG'),'-fgt2')]",
        "ARSpeer3": "[concat(parameters('TAG'),'-fgt3')]"
    },
    "resources": [
        {
            "type": "Microsoft.Network/virtualHubs",
            "apiVersion": "2020-06-01",
            "name": "[variables('fgRouteServerName')]",
            "location": "[parameters('location')]",
            "properties": {
                "sku": "Standard"
            }
        },
        {
            "type": "Microsoft.Network/virtualHubs/ipConfigurations",
            "apiVersion": "2020-06-01",
            "name": "[concat(variables('fgRouteServerName'), '/', 'ipconfig1') ]",
            "location": "[parameters('location')]",
            "dependsOn": [
                "[resourceId('Microsoft.Network/virtualHubs', variables('fgRouteServerName'))]"
            ],
            "properties": {
                "subnet": {
                    "id": "[parameters('RouteServerSubnetID')]"
                },
                "PublicIPAddress": { "id": "[parameters('RouteServerPIPID')]" } 
            }
        },
        {
            "type": "Microsoft.Network/virtualHubs/bgpConnections",
            "apiVersion": "2020-06-01",
            "name": "[concat(variables('fgRouteServerName'), '/', variables('ARSpeer1'))]",
            "dependsOn": [
                "[resourceId('Microsoft.Network/virtualHubs/ipConfigurations', variables('fgRouteServerName'), 'ipconfig1')]"
            ],
            "properties": {
                "peerAsn": "[parameters('peerasn')]",
                "peerIp": "[parameters('peer1ip')]"
            }
        },
        {
            "type": "Microsoft.Network/virtualHubs/bgpConnections",
            "apiVersion": "2020-06-01",
            "name": "[concat(variables('fgRouteServerName'), '/', variables('ARSpeer2'))]",
            "dependsOn": [
                "[resourceId('Microsoft.Network/virtualHubs/ipConfigurations', variables('fgRouteServerName'), 'ipconfig1')]",
                "[resourceId('Microsoft.Network/virtualHubs/bgpConnections', variables('fgRouteServerName'), variables('ARSpeer1'))]"
            ],
            "properties": {
                "peerAsn": "[parameters('peerasn')]",
                "peerIp": "[parameters('peer2ip')]"
            }
        },
        {
            "type": "Microsoft.Network/virtualHubs/bgpConnections",
            "apiVersion": "2020-06-01",
            "name": "[concat(variables('fgRouteServerName'), '/', variables('ARSpeer3'))]",
            "dependsOn": [
                "[resourceId('Microsoft.Network/virtualHubs/ipConfigurations', variables('fgRouteServerName'), 'ipconfig1')]",
                "[resourceId('Microsoft.Network/virtualHubs/bgpConnections', variables('fgRouteServerName'), variables('ARSpeer2'))]"
            ],
            "properties": {
                "peerAsn": "[parameters('peerasn')]",
                "peerIp": "[parameters('peer3ip')]"
            }
        }
    ],
    "outputs": {}
  }
TEMPLATE
}
