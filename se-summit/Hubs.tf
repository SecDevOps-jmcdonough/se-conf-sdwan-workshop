locals {
  project   = "${var.username}-workshop"
  rg_exists = true

  resource_group_hub_name     = local.rg_exists ? data.azurerm_resource_group.hubrg.0.name : azurerm_resource_group.hubrg.0.name
  resource_group_hub_location = local.rg_exists ? data.azurerm_resource_group.hubrg.0.location : azurerm_resource_group.hubrg.0.location
  resource_group_hub_id       = local.rg_exists ? data.azurerm_resource_group.hubrg.0.id : azurerm_resource_group.hubrg.0.id

}

//############################ Create Resource Group ##################

resource "azurerm_resource_group" "hubrg" {
  count = local.rg_exists ? 0 : 1

  name     = "${local.project}-${var.TAG}"
  location = var.hubrglocation
}

data "azurerm_resource_group" "hubrg" {
  count = local.rg_exists ? 1 : 0
  name  = "${local.project}-${var.TAG}"
}

//############################ Create Hub VNETs  ##################

resource "azurerm_virtual_network" "Hubs" {
  for_each            = var.az_hubs
  name                = "${local.project}-${var.TAG}-${each.value.name}"
  location            = each.value.location
  resource_group_name = local.resource_group_hub_name
  address_space       = [each.value.cidr]

  tags = {
    Project = "${local.project}"
    Role    = "${var.TAG}"
  }
}

//############################ Create Hub Subnets ############################

resource "azurerm_subnet" "hubsubnets" {
  for_each = var.az_hubsubnetscidrs

  name                 = each.value.name == "RouteServerSubnet" ? "${each.value.name}" : "${var.TAG}-${local.project}-subnet-${each.value.name}"
  resource_group_name  = local.resource_group_hub_name
  address_prefixes     = [each.value.cidr]
  virtual_network_name = azurerm_virtual_network.Hubs[each.value.vnet].name

}

//############################  Hub Route Tables ############################
resource "azurerm_route_table" "hubvnet_route_tables" {
  for_each = var.vnetroutetables

  name                = "${var.TAG}-${local.project}-${each.value.name}"
  location            = azurerm_virtual_network.Hubs[each.value.vnet].location
  resource_group_name = local.resource_group_hub_name

  disable_bgp_route_propagation = each.value.disablepropagation
  //disable_bgp_route_propagation = false
  tags = {
    Project = "${local.project}"
  }
}

//############################  RT Associations ############################
resource "azurerm_subnet_route_table_association" "vnet_rt_assoc" {
  for_each = var.vnetroutetables

  subnet_id = azurerm_subnet.hubsubnets[each.key].id
  #subnet_id      = data.azurerm_subnet.pub_subnet.id
  route_table_id = azurerm_route_table.hubvnet_route_tables[each.key].id
}

//############################  FGT NSGs ##################

resource "azurerm_network_security_group" "fgt_nsgs" {
  for_each = var.nsgs

  name                = "${var.TAG}-${local.project}-${each.value.vnet}-${each.value.name}"
  location            = azurerm_virtual_network.Hubs[each.value.vnet].location
  resource_group_name = local.resource_group_hub_name
}

resource "azurerm_network_security_rule" "fgt_nsg_rules" {
  for_each = var.nsgrules

  name                        = each.value.rulename
  resource_group_name         = local.resource_group_hub_name
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

//############################  FGTs NICs ############################


resource "azurerm_network_interface" "hub1fgt1nics" {
  for_each                      = var.hub1fgt1
  name                          = "${each.value.vnet}-${each.value.vmname}-${each.value.name}"
  location                      = azurerm_virtual_network.Hubs[each.value.vnet].location
  resource_group_name           = local.resource_group_hub_name
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
  resource_group_name           = local.resource_group_hub_name
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




//////////////////////////HUB1 FGT1//////////////////////////
data "template_file" "hub1fgt1_customdata" {
  template = file("./assets/fgt-hub-userdata.tpl")
  vars = {
    fgt_id               = "hub1-fgt1"
    fgt_license_file     = ""
    fgt_username         = var.username
    fgt_config_ha        = true
    fgt_config_autoscale = false
    fgt_ssh_public_key   = ""
    fgt_config_probe     = true

    Port1IP    = var.hub1fgt1["nic1"].ip
    Port1Alias = var.hub1fgt1["nic1"].alias
    Port2IP    = var.hub1fgt1["nic2"].ip
    Port2Alias = var.hub1fgt1["nic2"].alias
    Port3IP    = var.hub1fgt1["nic3"].ip
    Port3Alias = var.hub1fgt1["nic3"].alias
    Port4IP    = var.hub1fgt1["nic4"].ip
    Port4Alias = var.hub1fgt1["nic4"].alias

    port3subnetmask = cidrnetmask(var.az_hubsubnetscidrs["hub1_fgt_ha"].cidr)
    port4subnetmask = cidrnetmask(var.az_hubsubnetscidrs["hub1_fgt_mgmt"].cidr)

    fgt_external_gw = cidrhost(var.az_hubsubnetscidrs["hub1_fgt_public"].cidr, 1)
    fgt_internal_gw = cidrhost(var.az_hubsubnetscidrs["hub1_fgt_private"].cidr, 1)
    fgt_mgmt_gw     = cidrhost(var.az_hubsubnetscidrs["hub1_fgt_mgmt"].cidr, 1)

    fgt_ha_peerip   = var.hub1fgt2["nic3"].ip
    fgt_ha_priority = "100"
    vnet_network    = var.az_hubs["hub1"].cidr

    port_ha   = "port3"
    port_mgmt = "port4"

    fgt_config_bgp = true
    fgt_as         = var.az_fgtasn
    peer1          = cidrhost(element(azurerm_subnet.hubsubnets["hub1_RouteServer"].address_prefixes, 0), 4)
    peer2          = cidrhost(element(azurerm_subnet.hubsubnets["hub1_RouteServer"].address_prefixes, 0), 5)
    peer_as        = "65515"

    fgt_config_sdwan = true


  }
}

resource "azurerm_virtual_machine" "hub1fgt1" {
  name                         = "${var.TAG}-${local.project}-hub1-fgt1"
  location                     = azurerm_virtual_network.Hubs["hub1"].location
  resource_group_name          = local.resource_group_hub_name
  network_interface_ids        = [for nic in azurerm_network_interface.hub1fgt1nics : nic.id]
  primary_network_interface_id = element(values(azurerm_network_interface.hub1fgt1nics)[*].id, 0)
  vm_size                      = var.az_fgt_vmsize

  delete_os_disk_on_termination    = true
  delete_data_disks_on_termination = true

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
    name              = "${var.TAG}-${local.project}-hub1-fgt1_OSDisk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  storage_data_disk {
    name              = "${var.TAG}-${local.project}-hub1-fgt1_DataDisk"
    managed_disk_type = "Premium_LRS"
    create_option     = "Empty"
    lun               = 0
    disk_size_gb      = "20"
  }
  os_profile {
    computer_name  = "${var.TAG}-${local.project}-hub1-fgt1"
    admin_username = var.username
    admin_password = var.password
    custom_data    = data.template_file.hub1fgt1_customdata.rendered
  }

  os_profile_linux_config {
    disable_password_authentication = false
  }

  tags = {
    Project = "${local.project}"
  }

}
///////////////IAM////////////////
resource "azurerm_role_assignment" "hub1fgt1_reader" {
  scope                = local.resource_group_hub_id
  role_definition_name = "Reader"
  principal_id         = azurerm_virtual_machine.hub1fgt1.identity[0].principal_id
  depends_on = [
    azurerm_virtual_machine.hub1fgt1
  ]
}

//////////////////////////HUB1 FGT2//////////////////////////
data "template_file" "hub1fgt2_customdata" {
  template = file("./assets/fgt-hub-userdata.tpl")
  vars = {
    fgt_id               = "hub1-fgt2"
    fgt_license_file     = ""
    fgt_username         = var.username
    fgt_config_ha        = true
    fgt_config_autoscale = false
    fgt_ssh_public_key   = ""
    fgt_config_probe     = true

    Port1IP    = var.hub1fgt2["nic1"].ip
    Port1Alias = var.hub1fgt2["nic1"].alias
    Port2IP    = var.hub1fgt2["nic2"].ip
    Port2Alias = var.hub1fgt2["nic2"].alias
    Port3IP    = var.hub1fgt2["nic3"].ip
    Port3Alias = var.hub1fgt2["nic3"].alias
    Port4IP    = var.hub1fgt2["nic4"].ip
    Port4Alias = var.hub1fgt2["nic4"].alias

    port3subnetmask = cidrnetmask(var.az_hubsubnetscidrs["hub1_fgt_ha"].cidr)
    port4subnetmask = cidrnetmask(var.az_hubsubnetscidrs["hub1_fgt_mgmt"].cidr)

    fgt_external_gw = cidrhost(var.az_hubsubnetscidrs["hub1_fgt_public"].cidr, 1)
    fgt_internal_gw = cidrhost(var.az_hubsubnetscidrs["hub1_fgt_private"].cidr, 1)
    fgt_mgmt_gw     = cidrhost(var.az_hubsubnetscidrs["hub1_fgt_mgmt"].cidr, 1)


    fgt_ha_peerip   = var.hub1fgt1["nic3"].ip
    fgt_ha_priority = "50"
    vnet_network    = var.az_hubs["hub1"].cidr

    port_ha   = "port3"
    port_mgmt = "port4"


    fgt_config_bgp = true
    fgt_as         = var.az_fgtasn
    peer1          = cidrhost(element(azurerm_subnet.hubsubnets["hub1_RouteServer"].address_prefixes, 0), 4)
    peer2          = cidrhost(element(azurerm_subnet.hubsubnets["hub1_RouteServer"].address_prefixes, 0), 5)
    peer_as        = "65515"

    fgt_config_sdwan = true


  }
}

resource "azurerm_virtual_machine" "hub1fgt2" {
  name                         = "${var.TAG}-${local.project}-hub1-fgt2"
  location                     = azurerm_virtual_network.Hubs["hub1"].location
  resource_group_name          = local.resource_group_hub_name
  network_interface_ids        = [for nic in azurerm_network_interface.hub1fgt2nics : nic.id]
  primary_network_interface_id = element(values(azurerm_network_interface.hub1fgt2nics)[*].id, 0)
  vm_size                      = var.az_fgt_vmsize

  delete_os_disk_on_termination    = true
  delete_data_disks_on_termination = true

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
    name              = "${var.TAG}-${local.project}-hub1-fgt2_OSDisk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  storage_data_disk {
    name              = "${var.TAG}-${local.project}-hub1-fgt2_DataDisk"
    managed_disk_type = "Premium_LRS"
    create_option     = "Empty"
    lun               = 0
    disk_size_gb      = "20"
  }
  os_profile {
    computer_name  = "${var.TAG}-${local.project}-hub1-fgt2"
    admin_username = var.username
    admin_password = var.password
    custom_data    = data.template_file.hub1fgt2_customdata.rendered
  }

  os_profile_linux_config {
    disable_password_authentication = false
  }

  tags = {
    Project = "${local.project}"
  }

}
///////////////IAM////////////////
resource "azurerm_role_assignment" "hub1fgt2_reader" {
  scope                = local.resource_group_hub_id
  role_definition_name = "Reader"
  principal_id         = azurerm_virtual_machine.hub1fgt2.identity[0].principal_id
  depends_on = [
    azurerm_virtual_machine.hub1fgt2
  ]
}



//////////////////////////////////LB and NAT rules//////////////////////////////////////

resource "azurerm_public_ip" "hubpip" {
  for_each            = var.hubpublicip
  name                = "${var.TAG}-${local.project}-${each.value.name}"
  location            = azurerm_virtual_network.Hubs[each.value.vnet].location
  resource_group_name = local.resource_group_hub_name
  allocation_method   = "Static"
  sku                 = "Standard"

  tags = {
    Project = "${local.project}"
  }

}

resource "azurerm_lb" "hub1extlb" {
  for_each            = var.hubextlb
  name                = "${var.TAG}-${local.project}-${each.value.name}"
  location            = azurerm_virtual_network.Hubs[each.value.vnet].location
  resource_group_name = local.resource_group_hub_name
  sku                 = "Standard"

  frontend_ip_configuration {
    name                 = each.value.frontendip
    public_ip_address_id = (each.value.type == "external" ? azurerm_public_ip.hubpip[each.value.frontendip].id : null)

  }
  tags = {
    Project = "${local.project}"
  }
}


resource "azurerm_lb_nat_rule" "fgttfaccess" {
  for_each = var.hubextlbnat

  resource_group_name            = local.resource_group_hub_name
  loadbalancer_id                = azurerm_lb.hub1extlb[each.value.lb].id
  name                           = each.value.name
  protocol                       = each.value.protocol
  frontend_port                  = each.value.frontport
  backend_port                   = each.value.backport
  frontend_ip_configuration_name = each.value.frontendip
}

resource "azurerm_network_interface_nat_rule_association" "fgtmastertfaccess" {
  for_each = var.hubextlbnat

  network_interface_id  = (each.value.interfacenat == "fgt1-port4" ? azurerm_network_interface.hub1fgt1nics["nic4"].id : azurerm_network_interface.hub1fgt2nics["nic4"].id)
  ip_configuration_name = "ipconfig1"
  nat_rule_id           = azurerm_lb_nat_rule.fgttfaccess[each.key].id
}


resource "azurerm_lb_probe" "hubelbprobe" {
  for_each = var.hubextlb

  resource_group_name = local.resource_group_hub_name
  loadbalancer_id     = azurerm_lb.hub1extlb[each.key].id
  name                = "${each.value.name}-probe"
  port                = each.value.probe
}

resource "azurerm_lb_backend_address_pool" "hublbbackend" {
  for_each = var.hublbpools

  loadbalancer_id = azurerm_lb.hub1extlb[each.value.lb].id
  name            = each.value.pool
}

//////////////////////////////////Azure Route Server////////////////////////////////////


resource "azurerm_public_ip" "arspip" {
  name                = "${var.TAG}-${local.project}-arspip"
  location            = azurerm_virtual_network.Hubs["hub1"].location
  resource_group_name = local.resource_group_hub_name
  allocation_method   = "Static"
  sku                 = "Standard"

  tags = {
    Project = "${local.project}"
  }

}

resource "azurerm_resource_group_template_deployment" "AzureRouteServer" {

  lifecycle {
    ignore_changes = all
  }

  name                = "SDWAN-WOrkshop-ARS"
  resource_group_name = local.resource_group_hub_name
  deployment_mode     = "Incremental"
  debug_level         = "requestContent, responseContent"
  parameters_content = jsonencode({
    "project" = {
      value = local.project
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
        "ARSpeer2": "[concat(parameters('TAG'),'-fgt2')]"
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
        }
    ],
    "outputs": {}
  }
TEMPLATE


}




