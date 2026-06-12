# Terraform Basics - Documentation

## Table of Contents
1. [Provider](#1-provider)
2. [Variables](#2-variables)
3. [Resources](#3-resources)
4. [Locals](#4-locals)
5. [Outputs](#5-outputs)
6. [How to Run](#6-how-to-run)

---

## 1. Provider

### What is a Provider?
A provider is a plugin that Terraform uses to interact with cloud platforms, SaaS providers, and other APIs.

### Syntax
```hcl
provider "azurerm" {
  features {}
  # subscription_id = "your-subscription-id"
}
```

### Common Providers
| Provider | Cloud Platform |
|----------|----------------|
| azurerm | Microsoft Azure |
| aws | Amazon Web Services |
| google | Google Cloud Platform |
| kubernetes | Kubernetes |
| null | Null provider (testing) |
| random | Random values |

### Important Notes
- Most providers require authentication (env vars, config file, or credentials)
- Provider block usually goes in a separate `provider.tf` file
- Always include `features {}` for Azure provider

---

## 2. Variables

### What are Variables?
Variables make your Terraform code flexible and reusable. They allow you to parameterize your infrastructure.

### Types of Variables

#### String
```hcl
variable "name" {
  type        = string
  description = "A string value"
  default     = "example"
}
```

#### Number
```hcl
variable "count" {
  type    = number
  default = 5
}
```

#### Boolean
```hcl
variable "enabled" {
  type    = bool
  default = true
}
```

#### List
```hcl
variable "regions" {
  type    = list(string)
  default = ["eastus", "westus", "centralus"]
}
```

#### Map
```hcl
variable "vm_sizes" {
  type = map(string)
  default = {
    small  = "Standard_B1s"
    medium = "Standard_B2s"
    large  = "Standard_D2s_v3"
  }
}
```

#### Object
```hcl
variable "config" {
  type = object({
    name      = string
    location  = string
    is_enabled = bool
  })
  default = {
    name       = "myvm"
    location   = "eastus"
    is_enabled = true
  }
}
```

### How to Use Variables
```hcl
# In resources
resource "azurerm_resource_group" "example" {
  name     = var.resource_group_name  # Use "var." prefix
  location = var.location
}
```

### Passing Variables
```bash
# Via command line
terraform apply -var="location=westus"

# Via variable file
terraform apply -var-file="dev.tfvars"

# Via environment variable
export TF_VAR_location=westus
```

---

## 3. Resources

### What is a Resource?
A resource is an infrastructure object you want to create and manage (VMs, networks, storage, etc.).

### Syntax
```hcl
resource "resource_type" "local_name" {
  # Resource configuration
  attribute1 = value1
  attribute2 = value2

  # Nested blocks
  nested_block {
    key = "value"
  }
}
```

### Key Concepts

#### 1. Resource Type
- Format: `provider_resource_type`
- Example: `azurerm_virtual_network`, `aws_instance`

#### 2. Local Name (Identifier)
- Used to reference this resource elsewhere in the code
- Must be unique within the module
- Example: `example`, `my_vnet`, `vm1`

#### 3. Attributes
- Each resource type has its own set of attributes
- Some are required, some are optional
- Can reference other resources using `resource_type.resource_name.attribute`

### Resource Dependencies

#### Implicit Dependency (Automatic)
```hcl
resource "azurerm_virtual_network" "example" {
  # Terraform automatically knows this depends on the resource group
  resource_group_name = azurerm_resource_group.example.name
}
```

#### Explicit Dependency (Manual)
```hcl
resource "azurerm_subnet" "example" {
  # Explicitly tell Terraform this depends on the vnet
  depends_on = [azurerm_virtual_network.example]
}
```

### Count Meta-Argument
Create multiple resources from a single block:
```hcl
resource "azurerm_resource_group" "example" {
  count    = 3
  name     = "rg-${count.index}"
  location = "eastus"
}
```

---

## 4. Locals

### What are Locals?
Local values (locals) are temporary named values used to reduce repetition in your code.

### Syntax
```hcl
locals {
  name1 = value1
  name2 = value2
}
```

### Examples
```hcl
locals {
  # Combine strings
  full_name = "prefix-${var.name}"

  # Reference variables
  env = var.environment

  # Use functions
  lowercase_name = lower(var.name)

  # Combine maps
  common_tags = merge(var.tags, { environment = "dev" })
}
```

### When to Use Locals
- Avoid repeating expressions
- Create reusable values within a module
- Combine multiple inputs
- Use Terraform functions

---

## 5. Outputs

### What are Outputs?
Outputs expose values from your Terraform configuration, useful for:
- Displaying information after apply
- Passing values to other configurations
- Making values available for other modules

### Syntax
```hcl
output "output_name" {
  description = "What this output represents"
  value       = the_value
  sensitive   = false  # Set to true to hide in console
}
```

### Examples
```hcl
# Simple output
output "rg_name" {
  value = azurerm_resource_group.example.name
}

# With description
output "vm_public_ip" {
  description = "Public IP address of the VM"
  value       = azurerm_public_ip.example.ip_address
}

# List output
output "all_subnet_ids" {
  value = azurerm_subnet.example[*].id
}

# Map output
output "resource_info" {
  value = {
    name = azurerm_resource_group.example.name
    id   = azurerm_resource_group.example.id
  }
}

# Sensitive output (won't display after apply)
output "password" {
  value     = var.admin_password
  sensitive = true
}
```

---

## 6. How to Run

### Step 1: Initialize
```bash
terraform init
```
- Downloads provider plugins
- Initializes backend
- Creates .terraform directory

### Step 2: Validate
```bash
terraform validate
```
- Checks syntax
- Validates configuration

### Step 3: Plan
```bash
terraform plan
```
- Shows what will be created
- Use `-out=filename` to save plan

### Step 4: Apply
```bash
terraform apply
# or
terraform apply -var="location=westus"
# or
terraform apply -var-file="dev.tfvars"
```

### Step 5: Destroy
```bash
terraform destroy
```

---

## Quick Reference

### Terraform File Extensions
| Extension | Purpose |
|-----------|---------|
| `.tf` | Main configuration files |
| `.tfvars` | Variable values |
| `.tfstate.json` | State file (JSON format) |

### Common Commands
| Command | Description |
|---------|-------------|
| `terraform init` | Initialize |
| `terraform fmt` | Format code |
| `terraform validate` | Validate syntax |
| `terraform plan` | Preview changes |
| `terraform apply` | Apply changes |
| `terraform destroy` | Destroy resources |
| `terraform show` | Show current state |
| `terraform state list` | List resources |
| `terraform output` | Show outputs |

### Interpolation Syntax
| Syntax | Description |
|--------|-------------|
| `var.name` | Variable |
| `local.name` | Local value |
| `resource.id` | Resource attribute |
| `module.name.output` | Module output |
| `count.index` | Current index in count loop |
| `each.key` | Current key in for_each |
| `each.value` | Current value in for_each |