# Conditional Expressions

Conditional expressions in Terraform are used to define conditional logic within your configurations. They allow you to make decisions or set values based on conditions. Conditional expressions are typically used to control whether resources are created or configured based on the evaluation of a condition.

The syntax for a conditional expression in Terraform is:

```hcl
condition ? true_val : false_val

```

- `condition` is an expression that evaluates to either `true` or `false`.
- `true_val` is the value that is returned if the condition is `true`.
- `false_val` is the value that is returned if the condition is `false`.

Here are some common use cases and examples of how to use conditional expressions in Terraform:

## Conditional Resource Creation Example

```hcl
resource "azurerm_resource_group" "example" {
  count    = var.create_rg ? 1 : 0
  name     = "rg-example"
  location = "eastus"
}

```

In this example, the `count` attribute of the `azurerm_resource_group` resource uses a conditional expression. If the `create_rg` variable is `true`, it creates one resource group. If `create_rg` is `false`, it creates zero, effectively skipping resource creation.

# Conditional Variable Assignment Example

```hcl
variable "environment" {
  description = "Environment type"
  type        = string
  default     = "development"
}

variable "production_location" {
  description = "Azure region for production"
  type        = string
  default     = "eastus"
}

variable "development_location" {
  description = "Azure region for development"
  type        = string
  default     = "westeurope"
}

resource "azurerm_resource_group" "example" {
  name     = "rg-example"
  location = var.environment == "production" ? var.production_location : var.development_location
}

```

Here, the resource group’s location is chosen based on the value of the `environment` variable. If `environment` is `production`, it uses the production location; otherwise, it uses the development location.

## Conditional Resource Configuration

```hcl
resource "azurerm_network_security_group" "example" {
  name                = "nsg-example"
  location            = "eastus"
  resource_group_name = azurerm_resource_group.example.name

  security_rule {
    name                       = "SSH"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = var.enable_ssh ? "*" : ""
    destination_address_prefix = "*"
  }
}
```

In this example, the `source_address_prefix` is controlled by a conditional expression. If `enable_ssh` is `true`, SSH traffic is allowed from any source `("*")`. If `enable_ssh` is `false`, the rule is effectively disabled.

Conditional expressions in Terraform provide a powerful way to make decisions and customize your infrastructure deployments based on various conditions and variables. They enhance the flexibility and reusability of your Terraform configurations.
