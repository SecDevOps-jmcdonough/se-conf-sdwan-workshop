variable "TAG" {
  description = "Customer Prefix TAG of the created ressources"
  type        = string
}

variable "hubrglocation" {
  description = "Hub Resource Group Location"
}

//---------------Hubs -----------------

variable "az_hubs" {
  description = "List of Azure Hubs"
}

//---------------Hubs Subnets--------
variable "az_hubsubnetscidrs" {
  description = "Hub Subnets CIDRs"
}

variable "vnetroutetables" {
  description = "VNET Route Table names"
}

//---------------NSG--------
variable "nsgs" {
  description = "Network Security Groups"
}

variable "nsgrules" {
  description = "Network Security Group Rules"
}

//---------------BRNSG--------
variable "brnsgs" {
  description = "Network Security Groups"
}

variable "brnsgsrules" {
  description = "Network Security Group Rules"
}

//-------------------Hub1 NICs----------
variable "hub1fgt1" {
  description = "Azure FGT1 nics IP"
}

variable "hub1fgt2" {
  description = "Azure FGT2 nics IP"
}

variable "az_ilbip" {
  description = "Internal LBs IP"
  type        = list(string)
}

variable "az_lbprob" {
  description = "Internal LBs Port Probing"
}

variable "az_fgtasn" {
  description = "FGT ASN"
}

//-------------------Hub1 EXT LB----------
variable "hubpublicip" {
  description = "Hub Public IP"
}

variable "hubextlb" {
  description = "Hub Ext LB"
}

variable "hubextlbnat" {
  description = "Hub External NAT"
}

variable "hublbpools" {
  description = "Hub External NAT"
}

//-----------------FG information ---------------
variable "az_fgt_vmsize" {
  description = "FGT HUB VM size"
}

variable "az_lnx_vmsize" {
  description = "Linux VM size"
}

variable "az_FGT_IMAGE_SKU" {
  description = "Azure Marketplace default image sku hourly (PAYG 'fortinet_fg-vm_payg_2022') or byol (Bring your own license 'fortinet_fg-vm')"
}

variable "az_FGT_VERSION" {
  description = "FortiGate version by default the 'latest' available version in the Azure Marketplace is selected"
}

variable "az_FGT_OFFER" {
  description = "FortiGate version by default the 'latest' available version in the Azure Marketplace is selected"
}

//------------------------------

variable "username" {
}

variable "password" {
}

//---------------Spoke VNETs--------

variable "az_spokevnet" {
  description = "Spoke VNETs"
}

variable "az_spokevnetsubnet" {
  description = "Spokes VNETs Subnets CIDRs"
}

//---------------Branch Site VNETs--------

variable "az_branches" {
  description = "Spoke VNETs Location"
}

variable "az_branchsubnetscidrs" {
  description = "Branch Sites  CIDRs"
}

variable "branch_vnetroutetables" {
  description = "Branch Sites  CIDRs"
}

//---------------Branch FGTs-------

variable "branch1fgt1" {
  description = "Branch1 FGT1"
}

variable "branch1fgt2" {
  description = "Branch1 FGT1"
}

variable "branch2fgt1" {
  description = "Branch2 FGT1"
}

variable "branch2fgt2" {
  description = "Branch2 FGT2"
}

variable "branch3fgt1" {
  description = "Branch3 FGT1"
}

//---------------Branch VMs-------

variable "branchvm" {
  description = "Branch VM"
}

//---------------Branch LB and PIP-------
variable "branchpublicip" {
  description = "Branch PIPs"
}

variable "branchlb" {
  description = "Branch LB"
}

variable "brlb_frontend_ip_configurations" {
  description = " Branch LB Frontends"
}

variable "branchlbpools" {
  description = " Branch LB Pools"
}

variable "branchlbprobes" {
  description = "Branch LBs probes"
}

variable "branchlbrules" {
  description = "Branch LBs rules"
}

variable "branchlbnatrules" {
  description = "Branch LBs NAT rules"
}

variable "branchlboutboundrules" {
  description = "Branch LBs Outbound NAT rules"
}