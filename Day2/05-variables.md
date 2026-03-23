# Variables (Azure)

Input and output variables in Terraform are essential for parameterizing and sharing values within your Terraform configurations and modules. They allow you to make your configurations more dynamic, reusable, and flexible.

## Input Variables

Input and output variables in Terraform are essential for parameterizing and sharing values within your Terraform configurations and modules. They allow you to make your configurations more dynamic, reusable, and flexible. Here's how you define an input variable:

```hcl
variable "resource_group_name" {
  description = "Name of the Azure Resource Group"
  type        = string
  default     = "rg-default"
}

variable "location" {
  description = "Azure region where resources will be created"
  type        = string
  default     = "eastus"
}

```

In this example:

- `variable` declares input variables (`resource_group_name` and `location`).
- `description` provides a human-readable description of the variable.
- `type` specifies the data type of the variable (e.g., `string`, `number`, `list`, `map`, etc.).
- `default` provides a default value for the variable, which is optional.

You can then use the input variable within your module or configuration like this:

```hcl
resource "azurerm_resource_group" "example" {
  name     = var.resource_group_name
  location = var.location
}
```

You reference the input variables using `var.resource_group_name` and `var.location`

## Output Variables

Output variables allow you to expose values from your module or configuration, making them available for use in other parts of your Terraform setup. Here's how you define an output variable:

```hcl
output "resource_group_id" {
  description = "The ID of the created Resource Group"
  value       = azurerm_resource_group.example.id
}
```

In this example:

- `output` declares an output variable named `resource_group_id`.
- `description` provides a description of the output variable.
- `value` specifies the attribute being exposed (the resource group’s ID)..

You can reference output variables in the root module or in other modules by using the syntax.

```hcl
output "resource_group_id" {
  description = "The ID of the created Resource Group"
  value       = azurerm_resource_group.example.id
}
```

In this example:

- `output` declares an output variable named resource_group_id.

- `description` provides a description of the output variable.

- `value` specifies the attribute being exposed (the resource group’s ID).

You can reference output variables in the root module or in other modules:

```hcl
output "root_output" {
  value = module.network.resource_group_id
}
```

This allows you to share data and values between different parts of your Terraform configuration and create more modular and maintainable infrastructure‑as‑code setups.
