# Built-in Functions

Terraform is an infrastructure‑as‑code (IaC) tool that allows you to define and provision infrastructure resources in a declarative manner. Terraform provides a wide range of built‑in functions that you can use within your configuration files (written in HashiCorp Configuration Language, or HCL) to manipulate and transform data. These functions help you perform various tasks when defining your infrastructure.

Here are some commonly used built‑in functions in Terraform, shown with Azure‑related examples:

1. `concat(list1, list2, ...)`: Combines multiple lists into a single list.

```hcl
variable "locations1" {
  type    = list(string)
  default = ["eastus", "westeurope"]
}

variable "locations2" {
  type    = list(string)
  default = ["centralus", "uksouth"]
}

output "combined_locations" {
  value = concat(var.locations1, var.locations2)
}

```

2. `element(list, index)`: Returns the element at the specified index in a list.

```hcl
variable "regions" {
  type    = list(string)
  default = ["eastus", "westeurope", "centralus"]
}

output "selected_region" {
  value = element(var.regions, 1) # Returns "westeurope"
}

```

3. `length(list)`: Returns the number of elements in a list.

```hcl
variable "regions" {
  type    = list(string)
  default = ["eastus", "westeurope", "centralus"]
}

output "region_count" {
  value = length(var.regions) # Returns 3
}
```

4. `map(key, value)`: Creates a map from a list of keys and a list of values.

```hcl
variable "keys" {
  type    = list(string)
  default = ["name", "location"]
}

variable "values" {
  type    = list(any)
  default = ["rg-example", "eastus"]
}

output "rg_map" {
  value = map(var.keys, var.values) # Returns {"name" = "rg-example", "location" = "eastus"}
}

```

5. `lookup(map, key)`: Retrieves the value associated with a specific key in a map.

```hcl
variable "rg_map" {
  type    = map(string)
  default = {
    name     = "rg-example"
    location = "eastus"
  }
}

output "rg_name" {
  value = lookup(var.rg_map, "name") # Returns "rg-example"
}

```

6. `join(separator, list)`: Joins the elements of a list into a single string using the specified separator.

```hcl
variable "regions" {
  type    = list(string)
  default = ["eastus", "westeurope", "centralus"]
}

output "joined_regions" {
  value = join(", ", var.regions) # Returns "eastus, westeurope, centralus"
}

```

These are just a few examples of the built-in functions available in Terraform. You can find more functions and detailed documentation in the official Terraform documentation, which is regularly updated to include new features and improvements
