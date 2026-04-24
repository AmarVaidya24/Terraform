# Resource Group
resource "azurerm_resource_group" "example_rg" {
  name     = "rg-example"
  location = "centralindia"
}

# Virtual Network
resource "azurerm_virtual_network" "example_vnet" {
  name                = "vnet-example"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.example_rg.location
  resource_group_name = azurerm_resource_group.example_rg.name
}

# Subnet
resource "azurerm_subnet" "example_subnet" {
  name                 = "subnet-example"
  resource_group_name  = azurerm_resource_group.example_rg.name
  virtual_network_name = azurerm_virtual_network.example_vnet.name
  address_prefixes     = ["10.0.1.0/24"]

  depends_on = [azurerm_virtual_network.example_vnet]
}

# Network Interface
resource "azurerm_network_interface" "example_nic" {
  name                = "nic-example"
  location            = azurerm_resource_group.example_rg.location
  resource_group_name = azurerm_resource_group.example_rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.example_subnet.id
    private_ip_address_allocation = "Dynamic"
  }
}

# Virtual Machine
resource "azurerm_windows_virtual_machine" "example_vm" {
  name                = "vm-example"
  resource_group_name = azurerm_resource_group.example_rg.name
  location            = azurerm_resource_group.example_rg.location
  size                = var.vm_size
  admin_username      = var.admin_username
  admin_password      = var.admin_password

  network_interface_ids = [azurerm_network_interface.example_nic.id]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = var.os_disk_type
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2022-datacenter-g2"
    version   = "latest"
  }

  additional_capabilities {
    hibernation_enabled = var.hibernation_enabled
  }
}
