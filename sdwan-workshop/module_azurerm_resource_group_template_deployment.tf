locals {
  resource_group_template_deployments = {
    "sdwan_workshop_ars" = {
      resource_group_name = local.resource_group_name

      name            = "sdwan_workshop_ars"
      deployment_mode = "Incremental"
      debug_level     = "requestContent, responseContent"
      parameters_content = jsonencode(
        {
          "project" = {
            value = local.project
          },
          "tag" = {
            value = local.event
          },
          "location" = {
            value = module.module_azurerm_virtual_network["vnet_hub1"].virtual_network.location
          },
          "RouteServerSubnetID" = {
            value = module.module_azurerm_subnet["RouteServerSubnet"].subnet.id
          },
          "peer1ip" = {
            value = module.module_azurerm_network_interface["nic_hub1_fortigate_1_2"].network_interface.private_ip_address
          },
          "peer2ip" = {
            value = module.module_azurerm_network_interface["nic_hub1_fortigate_2_2"].network_interface.private_ip_address
          },
          "peerasn" = {
            value = "64622"
          },
          "RouteServerPIPID" = {
            value = module.module_azurerm_public_ip["pip_ars"].public_ip.id
          }
        }
      )
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
              "tag": {
                  "type": "string",
                  "metadata": {
                      "description": "Suffix"
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
              "fgRouteServerName": "[concat(parameters('project'),'-',parameters('tag'),'-RouteServer')]",
              "ARSpeer1": "[concat(parameters('project'),'-fgt-1')]",
              "ARSpeer2": "[concat(parameters('project'),'-fgt-2')]"
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
  }
}

module "module_azurerm_resource_group_template_deployment" {
  for_each = local.resource_group_template_deployments

  source = "../azure/rm/azurerm_resource_group_template_deployment"

  resource_group_name = each.value.resource_group_name

  name               = each.value.name
  deployment_mode    = each.value.deployment_mode
  parameters_content = each.value.parameters_content
  template_content   = each.value.template_content
  debug_level        = each.value.debug_level

  tags = local.tags
}

output "resource_group_template_deployments" {
  value = var.enable_module_output ? module.module_azurerm_resource_group_template_deployment[*] : null
}
