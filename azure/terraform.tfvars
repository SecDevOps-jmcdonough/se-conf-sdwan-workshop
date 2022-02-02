azsubscriptionid = ""

project  = "-workshop"
TAG      = "sdwan"
username = ""
password = "Fortinet20217!"

hubrglocation = "eastus"

//////////////////////////////////////////////////////////Hub Sites////////////////////////////////////////////////////////////////
az_hubs = {
  "hub1" = { name = "hub1", cidr = "10.10.0.0/16", location = "eastus" },
}

az_hubsubnetscidrs = {
  "hub1_fgt_public"  = { name = "fgt_public", cidr = "10.10.0.0/24", vnet = "hub1" },
  "hub1_fgt_private" = { name = "fgt_private", cidr = "10.10.1.0/24", vnet = "hub1" },
  "hub1_RouteServer" = { name = "RouteServerSubnet", cidr = "10.10.2.0/24", vnet = "hub1" }
}

vnetroutetables = {
  "hub1_fgt_public"  = { name = "hub1_fgt-pub_rt", vnet = "hub1" },
  "hub1_fgt_private" = { name = "hub1_fgt-priv_rt", vnet = "hub1" }
}


hub1fgt1 = {
  "nic1" = { vmname = "fgt1", name = "port1", subnet = "hub1_fgt_public", ip = "10.10.0.4", nsgname = "pub-nsg", vnet = "hub1" },
  "nic2" = { vmname = "fgt1", name = "port2", subnet = "hub1_fgt_private", ip = "10.10.1.4", nsgname = "priv-nsg", vnet = "hub1" },
}
hub1fgt2 = {
  "nic1" = { vmname = "fgt2", name = "port1", subnet = "hub1_fgt_public", ip = "10.10.0.5", nsgname = "pub-nsg", vnet = "hub1" },
  "nic2" = { vmname = "fgt2", name = "port2", subnet = "hub1_fgt_private", ip = "10.10.1.5", nsgname = "priv-nsg", vnet = "hub1" },
}

hub1fgt3 = {
  "nic1" = { vmname = "fgt3", name = "port1", subnet = "hub1_fgt_public", ip = "10.10.0.6", nsgname = "pub-nsg", vnet = "hub1" },
  "nic2" = { vmname = "fgt3", name = "port2", subnet = "hub1_fgt_private", ip = "10.10.1.6", nsgname = "priv-nsg", vnet = "hub1" },
}


az_ilbip = ["10.10.2.10", // Hub1 Internal LB Listner 
]
az_lbprob = "3422"

az_fgt_vmsize    = "Standard_F4s_v2"
az_FGT_IMAGE_SKU = "fortinet_fg-vm_payg_20190624"
az_FGT_VERSION   = "7.0.0"
az_FGT_OFFER     = "fortinet_fortigate-vm_v5"

az_fgtasn = "64622"




////////////////////NSG//////////////////

nsgs = {
  "pub-nsg"  = { name = "pub-nsg", vnet = "hub1" },
  "priv-nsg" = { name = "priv-nsg", vnet = "hub1" }
}

nsgrules = {
  "pub-nsg-inbound"   = { nsgname = "pub-nsg", rulename = "AllInbound", priority = "100", direction = "Inbound", access = "Allow" },
  "pub-nsg-outbound"  = { nsgname = "pub-nsg", rulename = "AllOutbound", priority = "100", direction = "Outbound", access = "Allow" },
  "priv-nsg-inbound"  = { nsgname = "priv-nsg", rulename = "AllInbound", priority = "100", direction = "Inbound", access = "Allow" },
  "priv-nsg-outbound" = { nsgname = "priv-nsg", rulename = "AllOutbound", priority = "100", direction = "Outbound", access = "Allow" },
}

////////////////////PIP and LB//////////////////

hubpublicip = {
  "hub-pip1" = { name = "hub-elbpip1", vnet = "hub1" },
}
hubextlb = {
  "hubextlb1" = { name = "hub1-elb1", vnet = "hub1", type = "external", probe = "8008", pool = "hub1-ext-fgt-aa", frontendip = "hub-pip1", subnet = "" }
}

hubextlbnat = {
  "fgt1https" = { name = "https-fgt1", lb = "hubextlb1", protocol = "Tcp", frontport = "1443", backport = "34443", frontendip = "hub-pip1", interfacenat = "fgt1-port1" },
  "fgt2https" = { name = "https-fgt2", lb = "hubextlb1", protocol = "Tcp", frontport = "2443", backport = "34443", frontendip = "hub-pip1", interfacenat = "fgt2-port1" },
  "fgt3https" = { name = "https-fgt3", lb = "hubextlb1", protocol = "Tcp", frontport = "3443", backport = "34443", frontendip = "hub-pip1", interfacenat = "fgt3-port1" },

  "fgt1ssh" = { name = "ssh-fgt1", lb = "hubextlb1", protocol = "Tcp", frontport = "1422", backport = "3422", frontendip = "hub-pip1", interfacenat = "fgt1-port1" },
  "fgt2ssh" = { name = "ssh-fgt2", lb = "hubextlb1", protocol = "Tcp", frontport = "2422", backport = "3422", frontendip = "hub-pip1", interfacenat = "fgt2-port1" },
  "fgt3ssh" = { name = "ssh-fgt3", lb = "hubextlb1", protocol = "Tcp", frontport = "3422", backport = "3422", frontendip = "hub-pip1", interfacenat = "fgt3-port1" },
}


//####################################Spoke Vnets#############################

az_spokevnet = {
  "spoke11" = { name = "spoke11", cidr = "10.11.0.0/16", location = "westeurope", peerto = "hub1" },
  "spoke12" = { name = "spoke12", cidr = "10.12.0.0/16", location = "northeurope", peerto = "hub1" }
}

az_spokevnetsubnet = {
  "spoke11_subnet" = { name = "spoke11-subnet1", cidr = "10.11.1.0/24", vnet = "spoke11" },
  "spoke12_subnet" = { name = "spoke12-subnet1", cidr = "10.12.1.0/24", vnet = "spoke12" }
}

az_lnx_vmsize = "Standard_D2_v3"

//////////////////////////////////////////////////////////Branch Sites////////////////////////////////////////////////////////////////

az_branches = {
  "branch1" = { name = "branch1", cidr = "172.16.0.0/16", location = "eastus" },
  "branch2" = { name = "branch2", cidr = "172.17.0.0/16", location = "eastus" },
  "branch3" = { name = "branch3", cidr = "172.18.0.0/16", location = "centralus" },
}

az_branchsubnetscidrs = {
  "branch1_fgt_public"  = { name = "br1_fgt_pub", cidr = "172.16.1.0/24", vnet = "branch1" },
  "branch1_fgt_private" = { name = "br1_fgt_priv", cidr = "172.16.2.0/24", vnet = "branch1" },
  "branch1_fgt_ha"      = { name = "br1_fgt_ha", cidr = "172.16.3.0/24", vnet = "branch1" },
  "branch1_fgt_mgmt"    = { name = "br1_fgt_mgmt", cidr = "172.16.4.0/24", vnet = "branch1" },
  "branch2_fgt_public"  = { name = "br2_fgt_pub", cidr = "172.17.1.0/24", vnet = "branch2" },
  "branch2_fgt_private" = { name = "br2_fgt_priv", cidr = "172.17.2.0/24", vnet = "branch2" },
  "branch2_fgt_ha"      = { name = "br1_fgt_ha", cidr = "172.17.3.0/24", vnet = "branch2" },
  "branch2_fgt_mgmt"    = { name = "br1_fgt_mgmt", cidr = "172.17.4.0/24", vnet = "branch2" },
  "branch3_fgt_public1" = { name = "br3_fgt_pub1", cidr = "172.18.1.0/24", vnet = "branch3" },
  "branch3_fgt_public2" = { name = "br3_fgt_pub2", cidr = "172.18.11.0/24", vnet = "branch3" },
  "branch3_fgt_private" = { name = "br3_fgt_priv", cidr = "172.18.2.0/24", vnet = "branch3" }
}

branch_vnetroutetables = {
  "branch1_fgt_private" = { name = "branch1_rt", vnet = "branch1" },
  "branch2_fgt_private" = { name = "branch2_rt", vnet = "branch2" },
  "branch3_fgt_private" = { name = "branch3_rt", vnet = "branch3" },
}


branch1fgt1 = {
  "nic1" = { vmname = "fgt1", name = "port1", alias = "isp1", subnet = "branch1_fgt_public", ip = "172.16.1.4", vnet = "branch1", pool = "branch1extlbpool1", nsgname = "br1-nsg" },
  "nic2" = { vmname = "fgt1", name = "port2", alias = "priv", subnet = "branch1_fgt_private", ip = "172.16.2.4", vnet = "branch1", pool = "branch1intlbpool1", nsgname = "br1-nsg" },
  "nic3" = { vmname = "fgt1", name = "port3", alias = "isp2", subnet = "branch1_fgt_public", ip = "172.16.1.14", vnet = "branch1", pool = "branch1extlbpool2", nsgname = "br1-nsg" },
  "nic4" = { vmname = "fgt1", name = "port4", alias = "ha", subnet = "branch1_fgt_ha", ip = "172.16.3.4", vnet = "branch1", pool = "branch1intlbparking", nsgname = "br1-nsg" },
  "nic5" = { vmname = "fgt1", name = "port5", alias = "mgmt", subnet = "branch1_fgt_mgmt", ip = "172.16.4.4", vnet = "branch1", pool = "branch1intlbparking", nsgname = "br1-nsg" }
}
branch1fgt2 = {
  "nic1" = { vmname = "fgt2", name = "port1", alias = "isp1", subnet = "branch1_fgt_public", ip = "172.16.1.5", vnet = "branch1", pool = "branch1extlbpool1", nsgname = "br1-nsg" },
  "nic2" = { vmname = "fgt2", name = "port2", alias = "priv", subnet = "branch1_fgt_private", ip = "172.16.2.5", vnet = "branch1", pool = "branch1intlbpool1", nsgname = "br1-nsg" },
  "nic3" = { vmname = "fgt2", name = "port3", alias = "isp2", subnet = "branch1_fgt_public", ip = "172.16.1.15", vnet = "branch1", pool = "branch1extlbpool2", nsgname = "br1-nsg" },
  "nic4" = { vmname = "fgt2", name = "port4", alias = "ha", subnet = "branch1_fgt_ha", ip = "172.16.3.5", vnet = "branch1", pool = "branch1intlbparking", nsgname = "br1-nsg" },
  "nic5" = { vmname = "fgt2", name = "port5", alias = "mgmt", subnet = "branch1_fgt_mgmt", ip = "172.16.4.5", vnet = "branch1", pool = "branch1intlbparking", nsgname = "br1-nsg" }
}

branch2fgt1 = {
  "nic1" = { vmname = "fgt1", name = "port1", alias = "isp1", subnet = "branch2_fgt_public", ip = "172.17.1.4", vnet = "branch2", pool = "branch2extlbpool1", nsgname = "br2-nsg" },
  "nic2" = { vmname = "fgt1", name = "port2", alias = "priv", subnet = "branch2_fgt_private", ip = "172.17.2.4", vnet = "branch2", pool = "branch2intlbpool1", nsgname = "br2-nsg" },
  "nic3" = { vmname = "fgt1", name = "port3", alias = "isp2", subnet = "branch2_fgt_public", ip = "172.17.1.14", vnet = "branch2", pool = "branch2extlbpool2", nsgname = "br2-nsg" },
  "nic4" = { vmname = "fgt1", name = "port4", alias = "ha", subnet = "branch2_fgt_ha", ip = "172.17.3.4", vnet = "branch2", pool = "branch2intlbparking", nsgname = "br2-nsg" },
  "nic5" = { vmname = "fgt1", name = "port5", alias = "mgmt", subnet = "branch2_fgt_mgmt", ip = "172.17.4.4", vnet = "branch2", pool = "branch2intlbparking", nsgname = "br2-nsg" }

}
branch2fgt2 = {
  "nic1" = { vmname = "fgt2", name = "port1", alias = "isp1", subnet = "branch2_fgt_public", ip = "172.17.1.5", vnet = "branch2", pool = "branch2extlbpool1", nsgname = "br2-nsg" },
  "nic2" = { vmname = "fgt2", name = "port2", alias = "priv", subnet = "branch2_fgt_private", ip = "172.17.2.5", vnet = "branch2", pool = "branch2intlbpool1", nsgname = "br2-nsg" },
  "nic3" = { vmname = "fgt2", name = "port3", alias = "isp2", subnet = "branch2_fgt_public", ip = "172.17.1.15", vnet = "branch2", pool = "branch2extlbpool2", nsgname = "br2-nsg" },
  "nic4" = { vmname = "fgt2", name = "port4", alias = "ha", subnet = "branch2_fgt_ha", ip = "172.17.3.5", vnet = "branch2", pool = "branch2intlbparking", nsgname = "br2-nsg" },
  "nic5" = { vmname = "fgt2", name = "port5", alias = "mgmt", subnet = "branch2_fgt_mgmt", ip = "172.17.4.5", vnet = "branch2", pool = "branch2intlbparking", nsgname = "br2-nsg" }
}
branch3fgt1 = {
  "nic1" = { vmname = "fgt1", name = "port1", alias = "isp1", subnet = "branch3_fgt_public1", ip = "172.18.1.4", vnet = "branch3", nsgname = "br3-nsg" },
  "nic2" = { vmname = "fgt1", name = "port2", alias = "priv", subnet = "branch3_fgt_private", ip = "172.18.2.4", vnet = "branch3", nsgname = "br3-nsg" },
  "nic3" = { vmname = "fgt1", name = "port3", alias = "isp2", subnet = "branch3_fgt_public2", ip = "172.18.11.14", vnet = "branch3", nsgname = "br3-nsg" },
}

branchpublicip = {
  "branch1-pip1" = { name = "br1-elbpip1", vnet = "branch1" },
  "branch1-pip2" = { name = "br1-elbpip2", vnet = "branch1" },
  "branch2-pip1" = { name = "br2-elbpip1", vnet = "branch2" },
  "branch2-pip2" = { name = "br2-elbpip2", vnet = "branch2" },
  "branch3-pip1" = { name = "br3-pip1", vnet = "branch3" },
  "branch3-pip2" = { name = "br3-pip2", vnet = "branch3" }
}


branchlb = {
  "branch1intlb" = { name = "br1-ilb", vnet = "branch1", type = "internal", subnet = "branch1_fgt_private" },
  "branch2intlb" = { name = "br2-ilb", vnet = "branch2", type = "internal", subnet = "branch2_fgt_private" },
  "branch1extlb" = { name = "br1-elb", vnet = "branch1", type = "external", subnet = "" },
  "branch2extlb" = { name = "br2-elb", vnet = "branch2", type = "external", subnet = "" }
}

brlb_frontend_ip_configurations = {
  "branch1intlbfront1" = { name = "fgt-front-1", lb = "branch1intlb", subnet = "branch1_fgt_private", frontendip = "172.16.2.10", type = "internal" },
  "branch2intlbfront1" = { name = "fgt-front-1", lb = "branch2intlb", subnet = "branch2_fgt_private", frontendip = "172.17.2.10", type = "internal" },
  "branch1extlbfront1" = { name = "fgt-front-1", lb = "branch1extlb", subnet = "", frontendip = "branch1-pip1", type = "external" },
  "branch1extlbfront2" = { name = "fgt-front-2", lb = "branch1extlb", subnet = "", frontendip = "branch1-pip2", type = "external" },
  "branch2extlbfront1" = { name = "fgt-front-1", lb = "branch2extlb", subnet = "", frontendip = "branch2-pip1", type = "external" },
  "branch2extlbfront2" = { name = "fgt-front-2", lb = "branch2extlb", subnet = "", frontendip = "branch2-pip2", type = "external" },
}

branchlbpools = {
  "branch1intlbpool1"   = { pool = "br1-int-fgt-ap", lb = "branch1intlb" },
  "branch2intlbpool1"   = { pool = "br2-int-fgt-ap", lb = "branch2intlb" },
  "branch1extlbpool1"   = { pool = "br1-ext-fgt-ap-port1", lb = "branch1extlb" },
  "branch1extlbpool2"   = { pool = "br1-ext-fgt-ap-port3", lb = "branch1extlb" },
  "branch2extlbpool1"   = { pool = "br2-ext-fgt-ap-port1", lb = "branch2extlb" },
  "branch2extlbpool2"   = { pool = "br2-ext-fgt-ap-port3", lb = "branch2extlb" },
  "branch1intlbparking" = { pool = "br1-int-parking", lb = "branch1intlb" },
  "branch2intlbparking" = { pool = "br2-int-parking", lb = "branch2intlb" },

}

branchlbprobes = {
  "branch1intlbprob1" = { name = "fgt-lbprobe", lb = "branch1intlb", port = "8008" },
  "branch2intlbprob1" = { name = "fgt-lbprobe", lb = "branch2intlb", port = "8008" },
  "branch1extlbprob1" = { name = "fgt-lbprobe", lb = "branch1extlb", port = "8008" },
  "branch2extlbprob1" = { name = "fgt-lbprobe", lb = "branch2extlb", port = "8008" },
}

branchlbrules = {
  "branch1intlbrule1" = { name = "fgt-haports", probe = "branch1intlbprob1", lb = "branch1intlb", protocol = "All", frontendport = "0", backendport = "0", frontendipname = "fgt-front-1", pool = "branch1intlbpool1" },
  "branch2intlbrule1" = { name = "fgt-haports", probe = "branch2intlbprob1", lb = "branch2intlb", protocol = "All", frontendport = "0", backendport = "0", frontendipname = "fgt-front-1", pool = "branch2intlbpool1" },
  "branch1extlbrule1" = { name = "udp-500-isp1", probe = "branch1extlbprob1", lb = "branch1extlb", protocol = "Udp", frontendport = "500", backendport = "500", frontendipname = "fgt-front-1", pool = "branch1extlbpool1" },
  "branch1extlbrule2" = { name = "udp-4500-isp1", probe = "branch1extlbprob1", lb = "branch1extlb", protocol = "Udp", frontendport = "4500", backendport = "4500", frontendipname = "fgt-front-1", pool = "branch1extlbpool1" },
  "branch1extlbrule3" = { name = "udp-500-isp2", probe = "branch1extlbprob1", lb = "branch1extlb", protocol = "Udp", frontendport = "500", backendport = "500", frontendipname = "fgt-front-2", pool = "branch1extlbpool2" },
  "branch1extlbrule4" = { name = "udp-4500-isp2", probe = "branch1extlbprob1", lb = "branch1extlb", protocol = "Udp", frontendport = "4500", backendport = "4500", frontendipname = "fgt-front-2", pool = "branch1extlbpool2" },
  "branch2extlbrule1" = { name = "udp-500-isp1", probe = "branch2extlbprob1", lb = "branch2extlb", protocol = "Udp", frontendport = "500", backendport = "500", frontendipname = "fgt-front-1", pool = "branch2extlbpool1" },
  "branch2extlbrule2" = { name = "udp-4500-isp1", probe = "branch2extlbprob1", lb = "branch2extlb", protocol = "Udp", frontendport = "4500", backendport = "4500", frontendipname = "fgt-front-1", pool = "branch2extlbpool1" },
  "branch2extlbrule3" = { name = "udp-500-isp2", probe = "branch2extlbprob1", lb = "branch2extlb", protocol = "Udp", frontendport = "500", backendport = "500", frontendipname = "fgt-front-2", pool = "branch2extlbpool2" },
  "branch2extlbrule4" = { name = "udp-4500-isp2", probe = "branch2extlbprob1", lb = "branch2extlb", protocol = "Udp", frontendport = "4500", backendport = "4500", frontendipname = "fgt-front-2", pool = "branch2extlbpool2" }

}

branchlbnatrules = {
  "br1fgt1https" = { name = "https-fgt1", lb = "branch1extlb", protocol = "Tcp", frontport = "1443", backport = "34443", frontendip = "fgt-front-1", interfacenat = "branch1-fgt1-port5" },
  "br1fgt2https" = { name = "https-fgt2", lb = "branch1extlb", protocol = "Tcp", frontport = "2443", backport = "34443", frontendip = "fgt-front-1", interfacenat = "branch1-fgt2-port5" },
  "br2fgt1https" = { name = "https-fgt1", lb = "branch2extlb", protocol = "Tcp", frontport = "1443", backport = "34443", frontendip = "fgt-front-1", interfacenat = "branch2-fgt1-port5" },
  "br2fgt2https" = { name = "https-fgt2", lb = "branch2extlb", protocol = "Tcp", frontport = "2443", backport = "34443", frontendip = "fgt-front-1", interfacenat = "branch2-fgt2-port5" },
  "br1fgt1ssh"   = { name = "ssh-fgt1", lb = "branch1extlb", protocol = "Tcp", frontport = "1422", backport = "3422", frontendip = "fgt-front-1", interfacenat = "branch1-fgt1-port5" },
  "br1fgt2ssh"   = { name = "ssh-fgt2", lb = "branch1extlb", protocol = "Tcp", frontport = "2422", backport = "3422", frontendip = "fgt-front-1", interfacenat = "branch1-fgt2-port5" },
  "br2fgt1ssh"   = { name = "ssh-fgt1", lb = "branch2extlb", protocol = "Tcp", frontport = "1422", backport = "3422", frontendip = "fgt-front-1", interfacenat = "branch2-fgt1-port5" },
  "br2fgt2ssh"   = { name = "ssh-fgt2", lb = "branch2extlb", protocol = "Tcp", frontport = "2422", backport = "3422", frontendip = "fgt-front-1", interfacenat = "branch2-fgt2-port5" },

}

branchlboutboundrules = {
  "br1outbound1" = { name = "OutboundRule1", lb = "branch1extlb", protocol = "All", pool = "branch1extlbpool1", frontendipname = "fgt-front-1" },
  "br1outbound2" = { name = "OutboundRule2", lb = "branch1extlb", protocol = "All", pool = "branch1extlbpool2", frontendipname = "fgt-front-2" },
  "br2outbound1" = { name = "OutboundRule1", lb = "branch2extlb", protocol = "All", pool = "branch2extlbpool1", frontendipname = "fgt-front-1" },
  "br2outbound2" = { name = "OutboundRule2", lb = "branch2extlb", protocol = "All", pool = "branch2extlbpool2", frontendipname = "fgt-front-2" }

}




////////////////////Branch NSG//////////////////

brnsgs = {
  "br1-nsg" = { name = "br1-nsg", vnet = "branch1" },
  "br2-nsg" = { name = "br2-nsg", vnet = "branch2" },
  "br3-nsg" = { name = "br3-nsg", vnet = "branch3" }
}


brnsgsrules = {
  "br1-inbound"  = { nsgname = "br1-nsg", rulename = "AllInbound", priority = "100", direction = "Inbound", access = "Allow" },
  "br1-outbound" = { nsgname = "br1-nsg", rulename = "AllOutbound", priority = "100", direction = "Outbound", access = "Allow" },
  "br2-inbound"  = { nsgname = "br2-nsg", rulename = "AllInbound", priority = "100", direction = "Inbound", access = "Allow" },
  "br2-outbound" = { nsgname = "br2-nsg", rulename = "AllOutbound", priority = "100", direction = "Outbound", access = "Allow" },
  "br3-inbound"  = { nsgname = "br3-nsg", rulename = "AllInbound", priority = "100", direction = "Inbound", access = "Allow" },
  "br3-outbound" = { nsgname = "br3-nsg", rulename = "AllOutbound", priority = "100", direction = "Outbound", access = "Allow" },
}

