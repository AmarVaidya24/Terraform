resource "azurerm_resource_group" "rg1" {
  name     = "ResourceGroup1"
  location = "westus"
}
resource "azurerm_resource_group" "rg2" {
  name     = "ResourceGroup2"
  location = "westus"
}

resource "azurerm_resource_group" "rg3" {
  name     = "ResourceGroup3"
  location = "westus"
}

# We can also use count to create multiple resources, but it is not as flexible as for_each when it comes to handling complex data structures.

resource "azurerm_resource_group" "rgs" {
  count    = 3
  name     = "ResourceGroup2-${count.index + 1}"
  location = "westus"
}


