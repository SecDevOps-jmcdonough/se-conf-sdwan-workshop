//############################ Create Branch VNETs  ##################

resource "azurerm_virtual_network" "branches" {
  for_each = var.az_branches

  name                = "${local.project}-${var.TAG}-${each.value.name}"
  location            = each.value.location
  resource_group_name = local.resource_group_hub_name
  address_space       = [each.value.cidr]

  tags = {
    Project = "${local.project}"
    Role    = "${var.TAG}"
  }
}

//############################ Create Branch Subnets ############################

resource "azurerm_subnet" "brsubnets" {
  for_each = var.az_branchsubnetscidrs

  name                 = each.value.name == "RouteServerSubnet" ? "${each.value.name}" : "${var.TAG}-${local.project}-subnet-${each.value.name}"
  resource_group_name  = local.resource_group_hub_name
  address_prefixes     = [each.value.cidr]
  virtual_network_name = azurerm_virtual_network.branches[each.value.vnet].name

}

//############################  Branch Route Tables ############################
resource "azurerm_route_table" "branchvnet_route_tables" {
  for_each = var.branch_vnetroutetables

  name                = "${var.TAG}-${local.project}-${each.value.name}"
  location            = azurerm_virtual_network.branches[each.value.vnet].location
  resource_group_name = local.resource_group_hub_name
  //disable_bgp_route_propagation = false
  tags = {
    Project = "${local.project}"
  }
}


//############################  RT Associations ############################
resource "azurerm_subnet_route_table_association" "brvnet_rt_assoc" {
  for_each = var.branch_vnetroutetables

  subnet_id = azurerm_subnet.brsubnets[each.key].id
  #subnet_id      = data.azurerm_subnet.pub_subnet.id
  route_table_id = azurerm_route_table.branchvnet_route_tables[each.key].id
}



//############################################################################################################################################

//############################  PIP ############################

resource "azurerm_public_ip" "branchpip" {
  for_each            = var.branchpublicip
  name                = "${var.TAG}-${local.project}-${each.value.name}"
  location            = azurerm_virtual_network.branches[each.value.vnet].location
  resource_group_name = local.resource_group_hub_name
  allocation_method   = "Static"
  sku                 = "Standard"
  availability_zone   = "No-Zone"

  tags = {
    Project = "${local.project}"
  }

}

//############################  Internal LB ############################

resource "azurerm_lb" "branchlb" {
  for_each = var.branchlb

  name                = "${var.TAG}-${local.project}-${each.value.name}"
  location            = azurerm_virtual_network.branches[each.value.vnet].location
  resource_group_name = local.resource_group_hub_name
  sku                 = "Standard"

  dynamic "frontend_ip_configuration" {
    for_each = [
      for fe_ip in var.brlb_frontend_ip_configurations : fe_ip
      if fe_ip.type == "external" && fe_ip.lb == each.key
    ]
    content {
      name                 = frontend_ip_configuration.value.name
      public_ip_address_id = azurerm_public_ip.branchpip[frontend_ip_configuration.value.frontendip].id
      availability_zone    = "No-Zone"
    }
  }

  dynamic "frontend_ip_configuration" {
    for_each = [
      for fe_ip in var.brlb_frontend_ip_configurations : fe_ip
      if fe_ip.type == "internal" && fe_ip.lb == each.key
    ]
    content {
      name                          = frontend_ip_configuration.value.name
      subnet_id                     = azurerm_subnet.brsubnets[frontend_ip_configuration.value.subnet].id
      private_ip_address            = frontend_ip_configuration.value.frontendip
      private_ip_address_allocation = "Static"
      availability_zone    = "No-Zone"
    }
  }

  tags = {
    Project = "${local.project}"
  }
}

resource "azurerm_lb_backend_address_pool" "brlbbackend" {
  for_each = var.branchlbpools

  loadbalancer_id = azurerm_lb.branchlb[each.value.lb].id
  name            = each.value.pool
}

resource "azurerm_lb_probe" "brilbprobe" {
  for_each = var.branchlbprobes

  resource_group_name = local.resource_group_hub_name
  loadbalancer_id     = azurerm_lb.branchlb[each.value.lb].id
  name                = each.value.name
  port                = each.value.port
}

resource "azurerm_lb_rule" "brilbrules" {
  for_each = var.branchlbrules

  resource_group_name = local.resource_group_hub_name
  loadbalancer_id     = azurerm_lb.branchlb[each.value.lb].id

  name          = each.value.name
  protocol      = each.value.protocol
  frontend_port = each.value.frontendport
  backend_port  = each.value.backendport

  frontend_ip_configuration_name = each.value.frontendipname
  probe_id                       = azurerm_lb_probe.brilbprobe[each.value.probe].id
  backend_address_pool_ids       = [azurerm_lb_backend_address_pool.brlbbackend[each.value.pool].id]
  disable_outbound_snat          = true
}



//############################  FGTs NICs ############################

resource "azurerm_network_interface" "branch1fgt1nic" {
  for_each                      = var.branch1fgt1
  name                          = "${each.value.vnet}-${each.value.vmname}-${each.value.name}"
  location                      = azurerm_virtual_network.branches[each.value.vnet].location
  resource_group_name           = local.resource_group_hub_name
  enable_ip_forwarding          = true
  enable_accelerated_networking = false

  ip_configuration {
    name      = "ipconfig1"
    subnet_id = azurerm_subnet.brsubnets[each.value.subnet].id
    #subnet_id                     = data.azurerm_subnet.dut1subnetid[each.key].id
    private_ip_address_allocation = "static"
    private_ip_address            = each.value.ip
    //public_ip_address_id          = (each.value.name == "port1" ? azurerm_public_ip.fgt3pip1.id : null)
  }
}
resource "azurerm_network_interface" "branch1fgt2nic" {
  for_each                      = var.branch1fgt2
  name                          = "${each.value.vnet}-${each.value.vmname}-${each.value.name}"
  location                      = azurerm_virtual_network.branches[each.value.vnet].location
  resource_group_name           = local.resource_group_hub_name
  enable_ip_forwarding          = true
  enable_accelerated_networking = false

  ip_configuration {
    name      = "ipconfig1"
    subnet_id = azurerm_subnet.brsubnets[each.value.subnet].id
    #subnet_id                     = data.azurerm_subnet.dut1subnetid[each.key].id
    private_ip_address_allocation = "static"
    private_ip_address            = each.value.ip
    //public_ip_address_id          = (each.value.name == "port1" ? azurerm_public_ip.fgt3pip1.id : null)
  }
}
resource "azurerm_network_interface" "branch2fgt1nic" {
  for_each                      = var.branch2fgt1
  name                          = "${each.value.vnet}-${each.value.vmname}-${each.value.name}"
  location                      = azurerm_virtual_network.branches[each.value.vnet].location
  resource_group_name           = local.resource_group_hub_name
  enable_ip_forwarding          = true
  enable_accelerated_networking = false

  ip_configuration {
    name      = "ipconfig1"
    subnet_id = azurerm_subnet.brsubnets[each.value.subnet].id
    #subnet_id                     = data.azurerm_subnet.dut1subnetid[each.key].id
    private_ip_address_allocation = "static"
    private_ip_address            = each.value.ip
    //public_ip_address_id          = (each.value.name == "port1" ? azurerm_public_ip.fgt3pip1.id : null)
  }
}
resource "azurerm_network_interface" "branch2fgt2nic" {
  for_each                      = var.branch2fgt2
  name                          = "${each.value.vnet}-${each.value.vmname}-${each.value.name}"
  location                      = azurerm_virtual_network.branches[each.value.vnet].location
  resource_group_name           = local.resource_group_hub_name
  enable_ip_forwarding          = true
  enable_accelerated_networking = false

  ip_configuration {
    name      = "ipconfig1"
    subnet_id = azurerm_subnet.brsubnets[each.value.subnet].id
    #subnet_id                     = data.azurerm_subnet.dut1subnetid[each.key].id
    private_ip_address_allocation = "static"
    private_ip_address            = each.value.ip
    //public_ip_address_id          = (each.value.name == "port1" ? azurerm_public_ip.fgt3pip1.id : null)
  }
}

resource "azurerm_network_interface" "branch3fgt1nic" {
  for_each                      = var.branch3fgt1
  name                          = "${each.value.vnet}-${each.value.vmname}-${each.value.name}"
  location                      = azurerm_virtual_network.branches[each.value.vnet].location
  resource_group_name           = local.resource_group_hub_name
  enable_ip_forwarding          = true
  enable_accelerated_networking = false

  ip_configuration {
    name                          = "ipconfig1"
    subnet_id                     = azurerm_subnet.brsubnets[each.value.subnet].id
    private_ip_address_allocation = "static"
    private_ip_address            = each.value.ip
    public_ip_address_id          = (each.value.name == "port1" ? azurerm_public_ip.branchpip["branch3-pip1"].id : (each.value.name == "port3" ? azurerm_public_ip.branchpip["branch3-pip2"].id : null))
  }
}

/////////////////////////////////////FGT NIC to AZURE LB POOL Association

resource "azurerm_network_interface_backend_address_pool_association" "branch1fgt1niclb" {
  for_each                = var.branch1fgt1
  network_interface_id    = azurerm_network_interface.branch1fgt1nic[each.key].id
  ip_configuration_name   = "ipconfig1"
  backend_address_pool_id = azurerm_lb_backend_address_pool.brlbbackend[each.value.pool].id

}

resource "azurerm_network_interface_backend_address_pool_association" "branch1fgt2niclb" {
  for_each = var.branch1fgt2

  network_interface_id    = azurerm_network_interface.branch1fgt2nic[each.key].id
  ip_configuration_name   = "ipconfig1"
  backend_address_pool_id = azurerm_lb_backend_address_pool.brlbbackend[each.value.pool].id
}

resource "azurerm_network_interface_backend_address_pool_association" "branch2fgt1niclb" {
  for_each = var.branch2fgt1

  network_interface_id    = azurerm_network_interface.branch2fgt1nic[each.key].id
  ip_configuration_name   = "ipconfig1"
  backend_address_pool_id = azurerm_lb_backend_address_pool.brlbbackend[each.value.pool].id
}

resource "azurerm_network_interface_backend_address_pool_association" "branch2fgt2niclb" {
  for_each = var.branch2fgt2

  network_interface_id    = azurerm_network_interface.branch2fgt2nic[each.key].id
  ip_configuration_name   = "ipconfig1"
  backend_address_pool_id = azurerm_lb_backend_address_pool.brlbbackend[each.value.pool].id
}

resource "azurerm_lb_nat_rule" "fgtbraccess" {
  for_each = var.branchlbnatrules

  resource_group_name            = local.resource_group_hub_name
  loadbalancer_id                = azurerm_lb.branchlb[each.value.lb].id
  name                           = each.value.name
  protocol                       = each.value.protocol
  frontend_port                  = each.value.frontport
  backend_port                   = each.value.backport
  frontend_ip_configuration_name = each.value.frontendip
}

resource "azurerm_network_interface_nat_rule_association" "fgtbraccessnic" {
  for_each = var.branchlbnatrules

  network_interface_id  = (each.value.interfacenat == "branch1-fgt1-port5" ? azurerm_network_interface.branch1fgt1nic["nic5"].id : (each.value.interfacenat == "branch1-fgt2-port5" ? azurerm_network_interface.branch1fgt2nic["nic5"].id : (each.value.interfacenat == "branch2-fgt1-port5" ? azurerm_network_interface.branch2fgt1nic["nic5"].id : azurerm_network_interface.branch2fgt2nic["nic5"].id)))
  ip_configuration_name = "ipconfig1"
  nat_rule_id           = azurerm_lb_nat_rule.fgtbraccess[each.key].id
}

resource "azurerm_lb_outbound_rule" "fgtbroutbound" {
  for_each = var.branchlboutboundrules

  resource_group_name     = local.resource_group_hub_name
  loadbalancer_id         = azurerm_lb.branchlb[each.value.lb].id
  name                    = each.value.name
  protocol                = each.value.protocol
  backend_address_pool_id = azurerm_lb_backend_address_pool.brlbbackend[each.value.pool].id

  frontend_ip_configuration {
    name = each.value.frontendipname
  }

}

resource "azurerm_network_security_group" "fgtbr_nsgs" {
  for_each = var.brnsgs

  name                = "${var.TAG}-${local.project}-${each.value.name}"
  location            = azurerm_virtual_network.branches[each.value.vnet].location
  resource_group_name = local.resource_group_hub_name
}

resource "azurerm_network_security_rule" "fgtbr_nsg_rules" {
  for_each = var.brnsgsrules

  name                        = each.value.rulename
  resource_group_name         = local.resource_group_hub_name
  network_security_group_name = azurerm_network_security_group.fgtbr_nsgs[each.value.nsgname].name
  priority                    = each.value.priority
  direction                   = each.value.direction
  access                      = each.value.access
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"

}


//############################ NIC to NSG ############################


resource "azurerm_network_interface_security_group_association" "br1fgt1nsg" {
  for_each                  = var.branch1fgt1
  network_interface_id      = azurerm_network_interface.branch1fgt1nic[each.key].id
  network_security_group_id = azurerm_network_security_group.fgtbr_nsgs[each.value.nsgname].id
}
resource "azurerm_network_interface_security_group_association" "br1fgt2nsg" {
  for_each                  = var.branch1fgt2
  network_interface_id      = azurerm_network_interface.branch1fgt2nic[each.key].id
  network_security_group_id = azurerm_network_security_group.fgtbr_nsgs[each.value.nsgname].id
}

resource "azurerm_network_interface_security_group_association" "br2fgt1nsg" {
  for_each                  = var.branch2fgt1
  network_interface_id      = azurerm_network_interface.branch2fgt1nic[each.key].id
  network_security_group_id = azurerm_network_security_group.fgtbr_nsgs[each.value.nsgname].id
}
resource "azurerm_network_interface_security_group_association" "br2fgt2nsg" {
  for_each                  = var.branch2fgt2
  network_interface_id      = azurerm_network_interface.branch2fgt2nic[each.key].id
  network_security_group_id = azurerm_network_security_group.fgtbr_nsgs[each.value.nsgname].id
}


resource "azurerm_network_interface_security_group_association" "br3fgt1nsg" {
  for_each                  = var.branch3fgt1
  network_interface_id      = azurerm_network_interface.branch3fgt1nic[each.key].id
  network_security_group_id = azurerm_network_security_group.fgtbr_nsgs[each.value.nsgname].id
}

//////////////////////////BR1 FGT1//////////////////////////
data "template_file" "br1fgt1_customdata" {
  template = file("./assets/fgt-br-userdata.tpl")
  vars = {
    fgt_id               = "br1fgt1"
    fgt_license_file     = ""
    fgt_username         = var.username
    fgt_config_ha        = true
    fgt_config_autoscale = false
    fgt_config_probe     = true
    fgt_ssh_public_key   = ""

    Port1IP    = var.branch1fgt1["nic1"].ip
    Port1Alias = var.branch1fgt1["nic1"].alias
    Port2IP    = var.branch1fgt1["nic2"].ip
    Port2Alias = var.branch1fgt1["nic2"].alias
    Port3IP    = var.branch1fgt1["nic3"].ip
    Port3Alias = var.branch1fgt1["nic3"].alias
    Port4IP    = var.branch1fgt1["nic4"].ip
    Port4Alias = var.branch1fgt1["nic4"].alias
    Port5Alias = var.branch1fgt1["nic5"].alias


    port1subnetmask = cidrnetmask(var.az_branchsubnetscidrs["branch1_fgt_public1"].cidr)
    port2subnetmask = cidrnetmask(var.az_branchsubnetscidrs["branch1_fgt_private"].cidr)
    port3subnetmask = cidrnetmask(var.az_branchsubnetscidrs["branch1_fgt_public2"].cidr)
    port4subnetmask = cidrnetmask(var.az_branchsubnetscidrs["branch1_fgt_ha"].cidr)

    fgt_external_gw = cidrhost(var.az_branchsubnetscidrs["branch1_fgt_public1"].cidr, 1)
    fgt_internal_gw = cidrhost(var.az_branchsubnetscidrs["branch1_fgt_private"].cidr, 1)
    fgt_mgmt_gw     = cidrhost(var.az_branchsubnetscidrs["branch1_fgt_mgmt"].cidr, 1)

    fgt_external_gw2 = cidrhost(var.az_branchsubnetscidrs["branch1_fgt_public2"].cidr, 1)
    isp2             = var.branch1fgt1["nic3"].name


    fgt_ha_peerip   = var.branch1fgt2["nic4"].ip
    fgt_ha_priority = "100"
    vnet_network    = var.az_branches["branch1"].cidr

    port_ha   = "port4"
    port_mgmt = "port5"

    fgt_config_sdwan = true
    remotegw1        = azurerm_public_ip.hubpip["hub-pip1"].ip_address
    remotegw2        = azurerm_public_ip.hubpip["hub-pip1"].ip_address
  }
}


resource "azurerm_virtual_machine" "br1fgt1" {
  name                         = "${var.TAG}-${local.project}-br1-fgt1"
  location                     = azurerm_virtual_network.branches["branch1"].location
  resource_group_name          = local.resource_group_hub_name
  network_interface_ids        = [for nic in azurerm_network_interface.branch1fgt1nic : nic.id]
  primary_network_interface_id = element(values(azurerm_network_interface.branch1fgt1nic)[*].id, 0)
  vm_size                      = "Standard_F8s"

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
    name              = "${var.TAG}-${local.project}-br1-fgt1_OSDisk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  storage_data_disk {
    name              = "${var.TAG}-${local.project}-br1-fgt1_DataDisk"
    managed_disk_type = "Premium_LRS"
    create_option     = "Empty"
    lun               = 0
    disk_size_gb      = "20"
  }
  os_profile {
    computer_name  = "${var.TAG}-${local.project}-br1-fgt1"
    admin_username = var.username
    admin_password = var.password
    custom_data    = data.template_file.br1fgt1_customdata.rendered
  }

  os_profile_linux_config {
    disable_password_authentication = false
  }

  tags = {
    Project = "${local.project}"
  }

}

///////////////IAM////////////////
resource "azurerm_role_assignment" "br1fgt1_reader" {
  scope                = local.resource_group_hub_id
  role_definition_name = "Reader"
  principal_id         = azurerm_virtual_machine.br1fgt1.identity[0].principal_id
  depends_on = [
    azurerm_virtual_machine.br1fgt1
  ]
}

//////////////////////////BR1 FGT2//////////////////////////

data "template_file" "br1fgt2_customdata" {
  template = file("./assets/fgt-br-userdata.tpl")
  vars = {
    fgt_id               = "br1fgt2"
    fgt_license_file     = ""
    fgt_username         = var.username
    fgt_config_ha        = true
    fgt_config_autoscale = false
    fgt_config_probe     = true
    fgt_ssh_public_key   = ""

    Port1IP    = var.branch1fgt2["nic1"].ip
    Port1Alias = var.branch1fgt2["nic1"].alias
    Port2IP    = var.branch1fgt2["nic2"].ip
    Port2Alias = var.branch1fgt2["nic2"].alias
    Port3IP    = var.branch1fgt2["nic3"].ip
    Port3Alias = var.branch1fgt2["nic3"].alias
    Port4IP    = var.branch1fgt2["nic4"].ip
    Port4Alias = var.branch1fgt2["nic4"].alias
    Port5Alias = var.branch1fgt2["nic5"].alias


    port1subnetmask = cidrnetmask(var.az_branchsubnetscidrs["branch1_fgt_public1"].cidr)
    port2subnetmask = cidrnetmask(var.az_branchsubnetscidrs["branch1_fgt_private"].cidr)
    port3subnetmask = cidrnetmask(var.az_branchsubnetscidrs["branch1_fgt_public2"].cidr)
    port4subnetmask = cidrnetmask(var.az_branchsubnetscidrs["branch1_fgt_ha"].cidr)

    fgt_external_gw = cidrhost(var.az_branchsubnetscidrs["branch1_fgt_public1"].cidr, 1)
    fgt_internal_gw = cidrhost(var.az_branchsubnetscidrs["branch1_fgt_private"].cidr, 1)
    fgt_mgmt_gw     = cidrhost(var.az_branchsubnetscidrs["branch1_fgt_mgmt"].cidr, 1)

    fgt_external_gw2 = cidrhost(var.az_branchsubnetscidrs["branch1_fgt_public2"].cidr, 1)
    isp2             = var.branch1fgt2["nic3"].name


    fgt_ha_peerip   = var.branch1fgt1["nic4"].ip
    fgt_ha_priority = "50"
    vnet_network    = var.az_branches["branch1"].cidr

    port_ha   = "port4"
    port_mgmt = "port5"

    fgt_config_sdwan = true
    remotegw1        = azurerm_public_ip.hubpip["hub-pip1"].ip_address
    remotegw2        = azurerm_public_ip.hubpip["hub-pip1"].ip_address

  }
}

resource "azurerm_virtual_machine" "br1fgt2" {
  name                         = "${var.TAG}-${local.project}-br1-fgt2"
  location                     = azurerm_virtual_network.branches["branch1"].location
  resource_group_name          = local.resource_group_hub_name
  network_interface_ids        = [for nic in azurerm_network_interface.branch1fgt2nic : nic.id]
  primary_network_interface_id = element(values(azurerm_network_interface.branch1fgt2nic)[*].id, 0)
  vm_size                      = "Standard_F8s"

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
    name              = "${var.TAG}-${local.project}-br1-fgt2_OSDisk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  storage_data_disk {
    name              = "${var.TAG}-${local.project}-br1-fgt2_DataDisk"
    managed_disk_type = "Premium_LRS"
    create_option     = "Empty"
    lun               = 0
    disk_size_gb      = "20"
  }
  os_profile {
    computer_name  = "${var.TAG}-${local.project}-br1-fgt2"
    admin_username = var.username
    admin_password = var.password
    custom_data    = data.template_file.br1fgt2_customdata.rendered
  }

  os_profile_linux_config {
    disable_password_authentication = false
  }

  tags = {
    Project = "${local.project}"
  }

}

///////////////IAM////////////////
resource "azurerm_role_assignment" "br1fgt2_reader" {
  scope                = local.resource_group_hub_id
  role_definition_name = "Reader"
  principal_id         = azurerm_virtual_machine.br1fgt2.identity[0].principal_id
  depends_on = [
    azurerm_virtual_machine.br1fgt2
  ]
}

//////////////////////////BR2 FGT1//////////////////////////
data "template_file" "br2fgt1_customdata" {
  template = file("./assets/fgt-br-userdata.tpl")
  vars = {
    fgt_id               = "br2fgt1"
    fgt_license_file     = ""
    fgt_username         = var.username
    fgt_config_ha        = true
    fgt_config_autoscale = false
    fgt_config_probe     = true
    fgt_ssh_public_key   = ""

    Port1IP    = var.branch2fgt1["nic1"].ip
    Port1Alias = var.branch2fgt1["nic1"].alias
    Port2IP    = var.branch2fgt1["nic2"].ip
    Port2Alias = var.branch2fgt1["nic2"].alias
    Port3IP    = var.branch2fgt1["nic3"].ip
    Port3Alias = var.branch2fgt1["nic3"].alias
    Port4IP    = var.branch2fgt1["nic4"].ip
    Port4Alias = var.branch2fgt1["nic4"].alias
    Port5Alias = var.branch2fgt1["nic5"].alias


    port1subnetmask = cidrnetmask(var.az_branchsubnetscidrs["branch2_fgt_public1"].cidr)
    port2subnetmask = cidrnetmask(var.az_branchsubnetscidrs["branch2_fgt_private"].cidr)
    port3subnetmask = cidrnetmask(var.az_branchsubnetscidrs["branch2_fgt_public2"].cidr)
    port4subnetmask = cidrnetmask(var.az_branchsubnetscidrs["branch2_fgt_ha"].cidr)

    fgt_external_gw = cidrhost(var.az_branchsubnetscidrs["branch2_fgt_public1"].cidr, 1)
    fgt_internal_gw = cidrhost(var.az_branchsubnetscidrs["branch2_fgt_private"].cidr, 1)
    fgt_mgmt_gw     = cidrhost(var.az_branchsubnetscidrs["branch2_fgt_mgmt"].cidr, 1)

    fgt_external_gw2 = cidrhost(var.az_branchsubnetscidrs["branch2_fgt_public2"].cidr, 1)
    isp2             = var.branch2fgt1["nic3"].name


    fgt_ha_peerip   = var.branch2fgt2["nic4"].ip
    fgt_ha_priority = "100"
    vnet_network    = var.az_branches["branch2"].cidr

    port_ha   = "port4"
    port_mgmt = "port5"

    fgt_config_sdwan = true
    remotegw1        = azurerm_public_ip.hubpip["hub-pip1"].ip_address
    remotegw2        = azurerm_public_ip.hubpip["hub-pip1"].ip_address

  }
}


resource "azurerm_virtual_machine" "br2fgt1" {
  name                         = "${var.TAG}-${local.project}-br2-fgt1"
  location                     = azurerm_virtual_network.branches["branch2"].location
  resource_group_name          = local.resource_group_hub_name
  network_interface_ids        = [for nic in azurerm_network_interface.branch2fgt1nic : nic.id]
  primary_network_interface_id = element(values(azurerm_network_interface.branch2fgt1nic)[*].id, 0)
  vm_size                      = "Standard_F8s"

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
    name              = "${var.TAG}-${local.project}-br2-fgt1_OSDisk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }
  storage_data_disk {
    name              = "${var.TAG}-${local.project}-br2-fgt1_DataDisk"
    managed_disk_type = "Premium_LRS"
    create_option     = "Empty"
    lun               = 0
    disk_size_gb      = "20"
  }
  os_profile {
    computer_name  = "${var.TAG}-${local.project}-br2-fgt1"
    admin_username = var.username
    admin_password = var.password
    custom_data    = data.template_file.br2fgt1_customdata.rendered
  }
  os_profile_linux_config {
    disable_password_authentication = false
  }
  tags = {
    Project = "${local.project}"
  }

}

///////////////IAM////////////////
resource "azurerm_role_assignment" "br2fgt1_reader" {
  scope                = local.resource_group_hub_id
  role_definition_name = "Reader"
  principal_id         = azurerm_virtual_machine.br2fgt1.identity[0].principal_id
  depends_on = [
    azurerm_virtual_machine.br2fgt1
  ]
}

//////////////////////////BR2 FGT2//////////////////////////

data "template_file" "br2fgt2_customdata" {
  template = file("./assets/fgt-br-userdata.tpl")
  vars = {
    fgt_id               = "br2fgt2"
    fgt_license_file     = ""
    fgt_username         = var.username
    fgt_config_ha        = true
    fgt_config_autoscale = false
    fgt_config_probe     = true
    fgt_ssh_public_key   = ""

    Port1IP    = var.branch2fgt2["nic1"].ip
    Port1Alias = var.branch2fgt2["nic1"].alias
    Port2IP    = var.branch2fgt2["nic2"].ip
    Port2Alias = var.branch2fgt2["nic2"].alias
    Port3IP    = var.branch2fgt2["nic3"].ip
    Port3Alias = var.branch2fgt2["nic3"].alias
    Port4IP    = var.branch2fgt2["nic4"].ip
    Port4Alias = var.branch2fgt2["nic4"].alias
    Port5Alias = var.branch2fgt2["nic5"].alias


    port1subnetmask = cidrnetmask(var.az_branchsubnetscidrs["branch2_fgt_public1"].cidr)
    port2subnetmask = cidrnetmask(var.az_branchsubnetscidrs["branch2_fgt_private"].cidr)
    port3subnetmask = cidrnetmask(var.az_branchsubnetscidrs["branch2_fgt_public2"].cidr)
    port4subnetmask = cidrnetmask(var.az_branchsubnetscidrs["branch2_fgt_ha"].cidr)

    fgt_external_gw = cidrhost(var.az_branchsubnetscidrs["branch2_fgt_public1"].cidr, 1)
    fgt_internal_gw = cidrhost(var.az_branchsubnetscidrs["branch2_fgt_private"].cidr, 1)
    fgt_mgmt_gw     = cidrhost(var.az_branchsubnetscidrs["branch2_fgt_mgmt"].cidr, 1)

    fgt_external_gw2 = cidrhost(var.az_branchsubnetscidrs["branch2_fgt_public2"].cidr, 1)
    isp2             = var.branch2fgt2["nic3"].name


    fgt_ha_peerip   = var.branch2fgt1["nic4"].ip
    fgt_ha_priority = "50"
    vnet_network    = var.az_branches["branch2"].cidr

    port_ha   = "port4"
    port_mgmt = "port5"

    fgt_config_sdwan = true
    remotegw1        = azurerm_public_ip.hubpip["hub-pip1"].ip_address
    remotegw2        = azurerm_public_ip.hubpip["hub-pip1"].ip_address

  }
}

resource "azurerm_virtual_machine" "br2fgt2" {
  name                         = "${var.TAG}-${local.project}-br2-fgt2"
  location                     = azurerm_virtual_network.branches["branch2"].location
  resource_group_name          = local.resource_group_hub_name
  network_interface_ids        = [for nic in azurerm_network_interface.branch2fgt2nic : nic.id]
  primary_network_interface_id = element(values(azurerm_network_interface.branch2fgt2nic)[*].id, 0)
  vm_size                      = "Standard_F8s"

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
    name              = "${var.TAG}-${local.project}-br2-fgt2_OSDisk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  storage_data_disk {
    name              = "${var.TAG}-${local.project}-br2-fgt2_DataDisk"
    managed_disk_type = "Premium_LRS"
    create_option     = "Empty"
    lun               = 0
    disk_size_gb      = "20"
  }
  os_profile {
    computer_name  = "${var.TAG}-${local.project}-br2-fgt2"
    admin_username = var.username
    admin_password = var.password
    custom_data    = data.template_file.br2fgt2_customdata.rendered
  }

  os_profile_linux_config {
    disable_password_authentication = false
  }

  tags = {
    Project = "${local.project}"
  }

}

///////////////IAM////////////////
resource "azurerm_role_assignment" "br2fgt2_reader" {
  scope                = local.resource_group_hub_id
  role_definition_name = "Reader"
  principal_id         = azurerm_virtual_machine.br2fgt2.identity[0].principal_id
  depends_on = [
    azurerm_virtual_machine.br2fgt2
  ]
}

//////////////////////////BR3 FGT1//////////////////////////

data "template_file" "br3fgt1_customdata" {
  template = file("./assets/fgt-br-userdata.tpl")
  vars = {
    fgt_id               = "br3fgt1"
    fgt_license_file     = ""
    fgt_username         = var.username
    fgt_config_ha        = false
    fgt_config_autoscale = false
    fgt_config_probe     = true
    fgt_ssh_public_key   = ""

    Port1IP    = var.branch3fgt1["nic1"].ip
    Port1Alias = var.branch3fgt1["nic1"].alias
    Port2IP    = var.branch3fgt1["nic2"].ip
    Port2Alias = var.branch3fgt1["nic2"].alias
    Port3IP    = var.branch3fgt1["nic3"].ip
    Port3Alias = var.branch3fgt1["nic3"].alias
    Port4IP    = ""
    Port4Alias = ""
    Port5Alias = ""



    port1subnetmask = cidrnetmask(var.az_branchsubnetscidrs["branch3_fgt_public1"].cidr)
    port2subnetmask = cidrnetmask(var.az_branchsubnetscidrs["branch3_fgt_private"].cidr)
    port3subnetmask = cidrnetmask(var.az_branchsubnetscidrs["branch3_fgt_public2"].cidr)

    fgt_external_gw = cidrhost(var.az_branchsubnetscidrs["branch3_fgt_public1"].cidr, 1)
    fgt_internal_gw = cidrhost(var.az_branchsubnetscidrs["branch3_fgt_private"].cidr, 1)

    fgt_external_gw2 = cidrhost(var.az_branchsubnetscidrs["branch3_fgt_public2"].cidr, 1)
    isp2             = var.branch3fgt1["nic3"].name

    vnet_network = var.az_branches["branch3"].cidr

    fgt_config_sdwan = true
    remotegw1        = azurerm_public_ip.hubpip["hub-pip1"].ip_address
    remotegw2        = azurerm_public_ip.hubpip["hub-pip1"].ip_address


  }
}

resource "azurerm_virtual_machine" "br3fgt1" {
  name                         = "${var.TAG}-${local.project}-br3-fgt1"
  location                     = azurerm_virtual_network.branches["branch3"].location
  resource_group_name          = local.resource_group_hub_name
  network_interface_ids        = [for nic in azurerm_network_interface.branch3fgt1nic : nic.id]
  primary_network_interface_id = element(values(azurerm_network_interface.branch3fgt1nic)[*].id, 0)
  vm_size                      = "Standard_D8as_v4"

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
    name              = "${var.TAG}-${local.project}-br3-fgt1_OSDisk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  storage_data_disk {
    name              = "${var.TAG}-${local.project}-br3-fgt1_DataDisk"
    managed_disk_type = "Premium_LRS"
    create_option     = "Empty"
    lun               = 0
    disk_size_gb      = "20"
  }
  os_profile {
    computer_name  = "${var.TAG}-${local.project}-br3-fgt1"
    admin_username = var.username
    admin_password = var.password
    custom_data    = data.template_file.br3fgt1_customdata.rendered
  }

  os_profile_linux_config {
    disable_password_authentication = false
  }

  tags = {
    Project = "${local.project}"
  }

}

///////////////IAM////////////////
resource "azurerm_role_assignment" "br3fgt1_reader" {
  scope                = local.resource_group_hub_id
  role_definition_name = "Reader"
  principal_id         = azurerm_virtual_machine.br3fgt1.identity[0].principal_id
  depends_on = [
    azurerm_virtual_machine.br3fgt1
  ]
}



//#########################################################Branch Sites VM#######################################################################

resource "azurerm_network_interface" "branchvmnics" {
  for_each = var.branchvm

  name                = "${var.TAG}-${local.project}-${each.value.vmname}-nic"
  location            = azurerm_virtual_network.branches[each.value.vnet].location
  resource_group_name = local.resource_group_hub_name

  enable_ip_forwarding          = false
  enable_accelerated_networking = false

  ip_configuration {
    name                          = "ipconfig1"
    subnet_id                     = azurerm_subnet.brsubnets[each.value.subnet].id
    private_ip_address_allocation = "Dynamic"
  }
  depends_on = [
    azurerm_virtual_machine.br1fgt1,
    azurerm_virtual_machine.br1fgt2,
    azurerm_virtual_machine.br2fgt1,
    azurerm_virtual_machine.br2fgt2,
    azurerm_virtual_machine.br3fgt1
  ]
}

data "template_file" "brlnx_customdata" {
  template = "./assets/lnx-spoke.tpl"

  vars = {
  }
}

resource "azurerm_virtual_machine" "branchlnx" {
  for_each = var.branchvm

  name                = "${var.TAG}-${local.project}-${each.value.vmname}"
  location            = azurerm_virtual_network.branches[each.value.vnet].location
  resource_group_name = local.resource_group_hub_name

  network_interface_ids = [azurerm_network_interface.branchvmnics[each.key].id]
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
    name              = "${var.TAG}-${local.project}-${each.value.vmname}-lnx-OSDisk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  os_profile {
    computer_name  = "${var.TAG}-${local.project}-${each.value.vmname}-lnx"
    admin_username = var.username
    admin_password = var.password
    custom_data    = data.template_file.brlnx_customdata.rendered
  }

  os_profile_linux_config {
    disable_password_authentication = false
  }

  tags = {
    Project = "${local.project}"
  }

}
