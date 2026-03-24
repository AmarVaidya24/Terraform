## Resouce Block Behaviour

A resource block tells Terraform:

`Create and manage this specific infrastructure object using the settings I define.`

```hcl
resource "<PROVIDER>_<TYPE>" "<NAME>" {
  # configuration arguments
}
```

Here’s a complete Terraform example showing how to use for_each with a subnet map. This pattern lets you define multiple subnets in a single block, driven by a variable:

```hcl

# Variables
variable "subnet_map" {
  description = "Map of subnet names to address prefixes"
  type        = map(string)

  default = {
    frontend = "10.0.1.0/24"
    backend  = "10.0.2.0/24"
    database = "10.0.3.0/24"
  }
}

# Provider
provider "azurerm" {
  features {}
}

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

# Subnets (using for_each)
resource "azurerm_subnet" "example" {
  for_each             = var.subnet_map
  name                 = each.key
  resource_group_name  = azurerm_resource_group.example_rg.name
  virtual_network_name = azurerm_virtual_network.example_vnet.name
  address_prefixes     = [each.value]
}

# Outputs
output "subnet_ids" {
  description = "IDs of all created subnets"
  value       = { for k, s in azurerm_subnet.example : k => s.id }
}

```

## How this works

- `subnet_map` is a variable mapping subnet names → CIDR ranges.

- `for_each` loops over that map, creating one subnet per entry.

- Each subnet gets its name from `each.key` and its prefix from `each.value`.

The output gives you a map of subnet names to their IDs, useful for attaching NICs or NSGs later.

# Resouce Block Dependencies

## Parallel execution.

**Parallel execution**: Terraform runs independent resources at the same time.

- Resources that have **no dependency relationship** can be `created`, `updated`, or `destroyed` in parallel.

- This speeds up execution because, for example, multiple independent subnets or storage accounts can be provisioned at the same time.
- Parallelism is controlled by the `-parallelism` flag (default is 10). Example:

```
terraform apply -parallelism=20
```

## Implicit dependencies

Automatically inferred when one resource references another.
Terraform automatically infers dependencies when one resource references another.

```hcl
resource "azurerm_virtual_network" "example_vnet" {
  name                = "vnet-example"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.example_rg.location
  resource_group_name = azurerm_resource_group.example_rg.name
}

resource "azurerm_subnet" "example_subnet" {
  name                 = "subnet-example"
  resource_group_name  = azurerm_resource_group.example_rg.name
  virtual_network_name = azurerm_virtual_network.example_vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}
```

- Here, the subnet depends on the VNet because it references `azurerm_virtual_network.example_vnet.name`.

- Terraform will **always create the VNet first** before the subnet, without you needing to specify depends_on.

## Explicit dependencies

Explicit dependencies: Manually declared with depends_on when Terraform cannot infer the relationship.

- Sometimes dependencies are not obvious from references.

- You can enforce them manually using the `depends_on` argument.

```hcl
resource "azurerm_network_interface" "example_nic" {
  name                = "nic-example"
  location            = azurerm_resource_group.example_rg.location
  resource_group_name = azurerm_resource_group.example_rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.example_subnet.id
    private_ip_address_allocation = "Dynamic"
  }

  depends_on = [azurerm_network_security_group.example_nsg]
}

```

- Even though the NIC doesn’t directly reference the NSG, `depends_on` ensures the NSG is created first.

- Explicit dependencies are useful when:
  - Resources are linked indirectly (e.g., via scripts, extensions, or external services).
  - You want to enforce a strict order of operations.

## Complete Code

```hcl
# Provider
provider "azurerm" {
  features {}
}

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
}

# Network Security Group
resource "azurerm_network_security_group" "example_nsg" {
  name                = "nsg-example"
  location            = azurerm_resource_group.example_rg.location
  resource_group_name = azurerm_resource_group.example_rg.name

  security_rule {
    name                       = "AllowRDP"
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

# Network Interface with explicit dependency
resource "azurerm_network_interface" "example_nic" {
  name                = "nic-example"
  location            = azurerm_resource_group.example_rg.location
  resource_group_name = azurerm_resource_group.example_rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.example_subnet.id
    private_ip_address_allocation = "Dynamic"
  }

  depends_on = [azurerm_network_security_group.example_nsg]
}

# Windows VM using the NIC
resource "azurerm_windows_virtual_machine" "example_vm" {
  name                = "vm-example"
  resource_group_name = azurerm_resource_group.example_rg.name
  location            = azurerm_resource_group.example_rg.location
  size                = "Standard_D2s_v3"
  admin_username      = "azureuser"
  admin_password      = "P@ssword1234!"

  network_interface_ids = [azurerm_network_interface.example_nic.id]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2022-datacenter-g2"
    version   = "latest"
  }
}

# Outputs
output "nic_id" {
  description = "The ID of the NIC"
  value       = azurerm_network_interface.example_nic.id
}

output "vm_id" {
  description = "The ID of the VM"
  value       = azurerm_windows_virtual_machine.example_vm.id
}
```
