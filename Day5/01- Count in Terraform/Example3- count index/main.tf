resource "azurerm_resource_group" "arg" {
  count    = 3
  name     = "example3-rg"
  location = "East US"
}

# if we want to create 3 NSGs, we can use the count index to reference the resource group for each NSG
resource "azurerm_network_security_group" "nsg" {
  name                = "example3-nsg"
  location            = azurerm_resource_group.arg.location
  resource_group_name = azurerm_resource_group.arg[0].name
}
