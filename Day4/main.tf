provider "azurerm" {
  features {

  }
  subscription_id = "<SUBSCRIPTION_ID>"
}

resource "azurerm_resource_group" "rg-hub01" {
  name     = "rg-hub01"
  location = "eastus"
  tags = {
    environment = "dev"
  }

}
