# ==============================================================================
# TERRAFORM BASICS - Simple Example
# ==============================================================================
# This file demonstrates the fundamental building blocks of Terraform
# ==============================================================================

# ------------------------------------------------------------------------------
# 1. PROVIDER
# ------------------------------------------------------------------------------
# Providers are plugins that interact with cloud platforms (Azure, AWS, GCP, etc.)
# They are responsible for understanding API interactions and exposing resources

provider "azurerm" {
  features {}
  # subscription_id = "your-subscription-id"  # Optional: if you have multiple subscriptions
}

# ------------------------------------------------------------------------------
# 2. VARIABLES
# ------------------------------------------------------------------------------
# Variables make your code flexible and reusable
# Define inputs that can be changed at runtime

# Simple variable
variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
  default     = "rg-example"  # Default value (optional)
}

# Variable with type constraint
variable "location" {
  description = "Azure region"
  type        = string
  default     = "eastus"
}

# Number variable
variable "vms_count" {
  description = "Number of VMs to create"
  type        = number
  default     = 1
}

# Boolean variable
variable "enable_monitoring" {
  description = "Enable monitoring"
  type        = bool
  default     = false
}

# List variable
variable "tags" {
  description = "Tags for resources"
  type        = list(string)
  default     = ["terraform", "learning", "basic"]
}

# Map variable
variable "vm_size_options" {
  description = "Available VM sizes"
  type        = map(string)
  default = {
    small  = "Standard_B1s"
    medium = "Standard_B2s"
    large  = "Standard_D2s_v3"
  }
}

# ------------------------------------------------------------------------------
# 3. RESOURCES
# ------------------------------------------------------------------------------
# Resources are the most important element in Terraform
# Each resource block describes infrastructure objects

# Resource 1: Resource Group
resource "azurerm_resource_group" "example" {
  # Resource type: azurerm_resource_group
  # Local name: example (used to reference this resource elsewhere)

  name     = var.resource_group_name
  location = var.location

  # Tags are optional metadata
  tags = {
    environment = "dev"
    purpose     = "learning"
  }
}

# Resource 2: Virtual Network
resource "azurerm_virtual_network" "example" {
  name                = "vnet-example"
  address_space       = ["10.0.0.0/16"]  # CIDR notation
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name

  # Reference another resource's attribute
  # Syntax: resource_type.resource_name.attribute
}

# Resource 3: Subnet
resource "azurerm_subnet" "example" {
  name                 = "subnet-example"
  resource_group_name  = azurerm_resource_group.example.name
  virtual_network_name = azurerm_virtual_network.example.name
  address_prefixes     = ["10.0.1.0/24"]
}

# Resource 4: Network Security Group (NSG)
resource "azurerm_network_security_group" "example" {
  name                = "nsg-example"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name

  # Security rule inside NSG
  security_rule {
    name                       = "allow-rdp"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "3389"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

# Resource 5: Network Interface
resource "azurerm_network_interface" "example" {
  name                = "nic-example"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.example.id
    private_ip_address_allocation = "Dynamic"
    # public_ip_address_id = azurerm_public_ip.example.id  # Optional: attach public IP
  }
}

# Resource 6: Virtual Machine (conditional based on count)
resource "azurerm_linux_virtual_machine" "example" {
  count               = var.vms_count
  name                = "vm-example-${count.index}"
  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_resource_group.example.location
  size                = var.vm_size_options["medium"]

  # VM credentials (use azure_key_vault_secret for production)
  admin_username = "adminuser"
  admin_password = "Password123!"

  # Network
  network_interface_ids = [azurerm_network_interface.example.id]

  # OS Disk
  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  # OS Image
  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "22.04-lts"
    version   = "latest"
  }
}

# ------------------------------------------------------------------------------
# 4. LOCALS
# ------------------------------------------------------------------------------
# Local values are temporary values that can be reused within a module
# They help avoid repetition and make code more maintainable

locals {
  # Combine multiple values
  common_tags = {
    environment = "dev"
    project     = "terraform-learning"
    created_by  = "terraform"
  }

  # Use functions
  current_date = formatdate("YYYY-MM-DD", timestamp())

  # Reference variables and resources
  full_rg_name = "${var.resource_group_name}-${local.current_date}"
}

# ------------------------------------------------------------------------------
# 5. OUTPUTS
# ------------------------------------------------------------------------------
# Outputs expose values from your Terraform code to the user or other modules

# Simple output
output "resource_group_name" {
  description = "Name of the resource group"
  value       = azurerm_resource_group.example.name
}

# Output with sensitivity (won't show in console)
output "admin_password" {
  description = "Admin password (sensitive)"
  value       = "Password123!"
  sensitive   = true
}

# Complex output - showing all VM names
output "vm_names" {
  description = "List of VM names"
  value       = azurerm_linux_virtual_machine.example[*].name
}

# Map output
output "vm_details" {
  description = "Map of VM properties"
  value = {
    name     = azurerm_linux_virtual_machine.example[0].name
    id       = azurerm_linux_virtual_machine.example[0].id
    location = azurerm_linux_virtual_machine.example[0].location
    size     = azurerm_linux_virtual_machine.example[0].size
  }
}

# Export all resources info
output "all_resources" {
  description = "All created resource info"
  value = {
    resource_group = {
      name = azurerm_resource_group.example.name
      id   = azurerm_resource_group.example.id
    }
    virtual_network = {
      name = azurerm_virtual_network.example.name
      id   = azurerm_virtual_network.example.id
    }
    subnet = {
      name = azurerm_subnet.example.name
      id   = azurerm_subnet.example.id
    }
    network_interface = {
      name = azurerm_network_interface.example.name
      id   = azurerm_network_interface.example.id
    }
  }
}