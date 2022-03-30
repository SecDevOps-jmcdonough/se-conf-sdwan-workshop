output "Hub1-fgt1https" {
  value = format(
    "https://%s:%s",
    module.module_azurerm_public_ip["pip_hub_elb_01"].public_ip.ip_address,
    module.module_azurerm_lb_nat_rule["hub1_fgt1_https"].lb_nat_rule.frontend_port
  )
}
output "Hub1-fgt2https" {
  value = format(
    "https://%s:%s",
    module.module_azurerm_public_ip["pip_hub_elb_01"].public_ip.ip_address,
    module.module_azurerm_lb_nat_rule["hub1_fgt2_https"].lb_nat_rule.frontend_port
  )
}

output "Hub1-fgt1ssh" {
  value = format(
    "ssh %s@%s:%s",
    var.username,
    module.module_azurerm_public_ip["pip_hub_elb_01"].public_ip.ip_address,
    module.module_azurerm_lb_nat_rule["hub1_fgt1_ssh"].lb_nat_rule.frontend_port
  )
}
output "Hub1-fgt2ssh" {
  value = format(
    "ssh %s@%s:%s",
    var.username,
    module.module_azurerm_public_ip["pip_hub_elb_01"].public_ip.ip_address,
    module.module_azurerm_lb_nat_rule["hub1_fgt2_ssh"].lb_nat_rule.frontend_port
  )
}


output "BR1-fgt1https" {
  value = format(
    "https://%s:%s",
    module.module_azurerm_public_ip["pip_br1_elb_01"].public_ip.ip_address,
    module.module_azurerm_lb_nat_rule["br1_fgt1_https"].lb_nat_rule.frontend_port
  )
}
output "BR1-fgt2https" {
  value = format(
    "https://%s:%s",
    module.module_azurerm_public_ip["pip_br1_elb_01"].public_ip.ip_address,
    module.module_azurerm_lb_nat_rule["br1_fgt2_https"].lb_nat_rule.frontend_port
  )
}

output "BR1-fgt1ssh" {
  value = format(
    "ssh %s@%s:%s",
    var.username,
    module.module_azurerm_public_ip["pip_br1_elb_01"].public_ip.ip_address,
    module.module_azurerm_lb_nat_rule["br1_fgt1_ssh"].lb_nat_rule.frontend_port
  )
}
output "BR1-fgt2ssh" {
  value = format(
    "ssh %s@%s:%s",
    var.username,
    module.module_azurerm_public_ip["pip_br1_elb_01"].public_ip.ip_address,
    module.module_azurerm_lb_nat_rule["br1_fgt2_ssh"].lb_nat_rule.frontend_port
  )
}

output "BR2-fgt1https" {
  value = format(
    "https://%s:%s",
    module.module_azurerm_public_ip["pip_br2_elb_01"].public_ip.ip_address,
    module.module_azurerm_lb_nat_rule["br2_fgt1_https"].lb_nat_rule.frontend_port
  )
}
output "BR2-fgt2https" {
  value = format(
    "https://%s:%s",
    module.module_azurerm_public_ip["pip_br2_elb_01"].public_ip.ip_address,
    module.module_azurerm_lb_nat_rule["br2_fgt2_https"].lb_nat_rule.frontend_port
  )
}

output "BR2-fgt1ssh" {
  value = format(
    "ssh %s@%s:%s",
    var.username,
    module.module_azurerm_public_ip["pip_br2_elb_01"].public_ip.ip_address,
    module.module_azurerm_lb_nat_rule["br2_fgt1_ssh"].lb_nat_rule.frontend_port
  )
}
output "BR2-fgt2ssh" {
  value = format(
    "ssh %s@%s:%s",
    var.username,
    module.module_azurerm_public_ip["pip_br2_elb_01"].public_ip.ip_address,
    module.module_azurerm_lb_nat_rule["br2_fgt2_ssh"].lb_nat_rule.frontend_port
  )
}

output "BR3-fgthttps" {
  value = format(
    "https://%s:%s",
    module.module_azurerm_public_ip["pip_br3_01"].public_ip.ip_address,
    "34443"
  )
}
output "BR3-fgtssh" {
  value = format(
    "ssh %s@%s:%s",
    var.username,
    module.module_azurerm_public_ip["pip_br3_01"].public_ip.ip_address,
    "3422"
  )
}

output "username" {
  value = format("username: %s", var.username)
}
output "password" {
  value = format("password: %s", var.password)
}


