# if we dont want to create resouce groups, we can set the count to 0
resource "azurerm_resource_group" "arg" {
  count    = 0
  name     = "example4-rg"
  location = "East US"
}

# with conditional count, we can create NSGs only if the resource group is created
resource "azurerm_network_security_group" "nsg" {
  count               = length(azurerm_resource_group.arg) > 0 ? 3 : 0
  name                = "example4-nsg"
  location            = azurerm_resource_group.arg[0].location
  resource_group_name = azurerm_resource_group.arg[0].name
}

