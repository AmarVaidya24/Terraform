# Variables Demo


# Define an input variable for the VM size
variable "vm_size" {
  description = "Azure Virtual Machine size"
  type        = string
  default     = "Standard_B1s"
}

# Define an input variable for the VM admin username
variable "admin_username" {
  description = "Admin username for the VM"
  type        = string
  default     = "azureuser"
}

# Define an input variable for the VM admin password
variable "admin_password" {
  description = "Admin password for the VM"
  type        = string
  sensitive   = true
}

# Configure the Azure provider
provider "azurerm" {
  features {}
}

# Create a Resource Group
resource "azurerm_resource_group" "example_rg" {
  name     = "rg-example"
  location = "eastus"
}

# Create a Virtual Machine using the input variables
resource "azurerm_windows_virtual_machine" "example_vm" {
  name                = "vm-example"
  resource_group_name = azurerm_resource_group.example_rg.name
  location            = azurerm_resource_group.example_rg.location
  size                = var.vm_size
  admin_username      = var.admin_username
  admin_password      = var.admin_password

  network_interface_ids = []
  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2019-Datacenter"
    version   = "latest"
  }
}

# Define an output variable to expose the VM ID
output "vm_id" {
  description = "The ID of the created Azure Virtual Machine"
  value       = azurerm_windows_virtual_machine.example_vm.id
}
