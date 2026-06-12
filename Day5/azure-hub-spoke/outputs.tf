output "resource_group_name" {
  value = azurerm_resource_group.rg.name
}

output "hub_vnet_id" {
  value = azurerm_virtual_network.hub.id
}

output "prod_vnet_id" {
  value = azurerm_virtual_network.prod.id
}

output "test_vnet_id" {
  value = azurerm_virtual_network.test.id
}

output "appgw_public_ip" {
  value = azurerm_public_ip.appgw_pip.ip_address
}
