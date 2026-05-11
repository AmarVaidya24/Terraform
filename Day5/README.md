# Terraform Learning Path

## Overview
This repository contains Terraform examples organized from basics to advanced concepts.

---

## Learning Order

### 1. Basics (Start Here)
- **00-Basics** - Your first Terraform file (provider, resource, variable, output)

### 2. Intermediate Concepts
- **01-Count** - Create multiple resources using `count`
- **02-Looping** - Use `for_each` to create resources from maps
- **03-Functions** - Built-in Terraform functions (lookup, coalesce, merge, try)
- **04-State** - Remote state management with Azure Storage

### 3. Advanced Concepts
- **05-Provisioners** - Run scripts after resource creation (local-exec, remote-exec)
- **06-Modules** - Reusable Terraform code

---

## Missing Concepts (Not Covered)

| Concept | Description | Use Case |
|---------|-------------|----------|
| **Data Sources** | Read existing infrastructure | Import existing resources without managing them |
| **Lifecycle** | Control resource creation order | `create_before_destroy`, `prevent_destroy` |
| **Dynamic Blocks** | Generate repeatable nested blocks | Multiple security rules, NSG rules |
| **Import** | Import existing resources into Terraform | Bring existing infrastructure under TF management |
| **Workspaces** | Manage multiple environments | Dev/Stage/Prod environments |
| **Sensitive Values** | Mask sensitive data in output | Hide passwords, keys |
| **Debugging** | TF_LOG for troubleshooting | Debug plan/apply issues |
| **Taint/Untaint** | Mark resources for recreation | Force resource recreation |

---

## Quick Start

```bash
# Initialize Terraform
terraform init

# Preview changes
terraform plan

# Apply changes
terraform apply

# Destroy resources
terraform destroy
```

---

## Terraform Commands Cheat Sheet

| Command | Description |
|---------|-------------|
| `terraform init` | Initialize working directory |
| `terraform validate` | Validate syntax |
| `terraform plan` | Show changes without applying |
| `terraform apply` | Apply changes |
| `terraform destroy` | Destroy all resources |
| `terraform output` | Show output values |
| `terraform state list` | List all resources |
| `terraform state show <resource>` | Show resource details |