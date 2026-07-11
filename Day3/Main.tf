provider "azurerm" {
  features {

  }
  subscription_id = "<SUBSCRIPTION_ID>"
}

resource "azurerm_resource_group" "rg-hub02" {
  name     = "rg-hub02"
  location = "CentralIndia"
  tags = {
    created_on  = timestamp()
    environment = "Uat3"
    location    = "CentralIndia"
  }
}
# Virtual Network
resource "azurerm_virtual_network" "vnet-hub02" {
  name                = "vnet-hub02"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.rg-hub02.location
  resource_group_name = azurerm_resource_group.rg-hub02.name
}

resource "azurerm_subnet" "subnet-hub02" {
  name                 = "subnet-hub02"
  resource_group_name  = azurerm_resource_group.rg-hub02.name
  virtual_network_name = azurerm_virtual_network.vnet-hub02.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_network_security_group" "nsg-hub02" {
  name                = "nsg-hub02"
  location            = azurerm_resource_group.rg-hub02.location
  resource_group_name = azurerm_resource_group.rg-hub02.name

  security_rule {
    name                       = "Allow-HTTP"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  lifecycle {
    precondition {
      condition     = contains(azurerm_subnet.subnet-hub02.address_prefixes, "10.0.1.0/24")
      error_message = "Subnet 'subnet-hub02' must use address prefix 10.0.1.0/24."
    }

    postcondition {
      condition     = length(self.security_rule) > 0
      error_message = "NSG 'nsg-hub02' must be created successfully."
    }
  }
}

output "resource_group_id" {
  description = "The ID of the created Resource Group"
  value       = azurerm_resource_group.rg-hub02.id
}
