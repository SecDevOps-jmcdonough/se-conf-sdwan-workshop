output "Hub-fgt1https" {
  value = format("https://%s:%s", azurerm_public_ip.hubpip["hub-pip1"].ip_address, var.hubextlbnat["fgt1https"].frontport)
}
output "Hub-fgt2https" {
  value = format("https://%s:%s", azurerm_public_ip.hubpip["hub-pip1"].ip_address, var.hubextlbnat["fgt2https"].frontport)
}

output "Hub-fgt1ssh" {
  value = format("ssh %s@%s:%s", var.username, azurerm_public_ip.hubpip["hub-pip1"].ip_address, var.hubextlbnat["fgt1ssh"].frontport)
}
output "Hub-fgt2ssh" {
  value = format("ssh %s@%s:%s", var.username, azurerm_public_ip.hubpip["hub-pip1"].ip_address, var.hubextlbnat["fgt2ssh"].frontport)
}


output "BR1-fgt1https" {
  value = format("https://%s:%s", azurerm_public_ip.branchpip["branch1-pip1"].ip_address, var.branchlbnatrules["br1fgt1https"].frontport)
}
output "BR1-fgt2https" {
  value = format("https://%s:%s", azurerm_public_ip.branchpip["branch1-pip1"].ip_address, var.branchlbnatrules["br1fgt2https"].frontport)
}

output "BR1-fgt1ssh" {
  value = format("ssh %s@%s:%s", var.username, azurerm_public_ip.branchpip["branch1-pip1"].ip_address, var.branchlbnatrules["br1fgt1ssh"].frontport)
}
output "BR1-fgt2ssh" {
  value = format("ssh %s@%s:%s", var.username, azurerm_public_ip.branchpip["branch1-pip1"].ip_address, var.branchlbnatrules["br1fgt2ssh"].frontport)
}

output "BR2-fgt1https" {
  value = format("https://%s:%s", azurerm_public_ip.branchpip["branch2-pip1"].ip_address, var.branchlbnatrules["br1fgt1https"].frontport)
}
output "BR2-fgt2https" {
  value = format("https://%s:%s", azurerm_public_ip.branchpip["branch2-pip1"].ip_address, var.branchlbnatrules["br2fgt2https"].frontport)
}

output "BR2-fgt1ssh" {
  value = format("ssh %s@%s:%s", var.username, azurerm_public_ip.branchpip["branch2-pip1"].ip_address, var.branchlbnatrules["br2fgt1ssh"].frontport)
}
output "BR2-fgt2ssh" {
  value = format("ssh %s@%s:%s", var.username, azurerm_public_ip.branchpip["branch2-pip1"].ip_address, var.branchlbnatrules["br2fgt2ssh"].frontport)
}


output "BR3-fgthttps" {
  value = format("https://%s:34443", azurerm_public_ip.branchpip["branch3-pip1"].ip_address)
}
output "BR3-fgtssh" {
  value = format("https://%s:3422", azurerm_public_ip.branchpip["branch3-pip1"].ip_address)
}



output "username" {
  value = format("username: %s", var.username)
}
output "password" {
  value = format("password: %s", var.password)
}


