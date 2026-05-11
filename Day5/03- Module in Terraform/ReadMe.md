# Module in Terraform

## Overview
This example demonstrates how to create reusable Terraform modules to provision Azure Virtual Machines.

## Directory Structure
```
Day5/03- Module in Terraform/
├── main.tf              # Root module calling the child module
├── variables.tf         # Root module variables
├── outputs.tf           # Root module outputs
├── provider.tf          # Provider configuration
└── modules/
    └── vm/              # Child module
        ├── main.tf      # VM resource configuration
        ├── variables.tf # Module variables
        └── outputs.tf   # Module outputs
```

## Module Variables
The child module accepts the following variables:
- `rg_name` - Name of the resource group
- `location` - Azure location
- `vm_name` - Name of the Virtual Machine
- `vm_size` - VM size (default: Standard_D2s_v3)
- `admin_username` - Admin username (default: azureuser)
- `admin_password` - Admin password (sensitive)
- `os_disk_type` - OS disk type (default: Standard_LRS)
- `hibernation_enabled` - Enable hibernation (default: false)

## How to Run

**Run below commands in sequence:**
```bash
# Initialize Terraform
terraform init

# Preview changes
terraform plan

# Apply changes
terraform apply

# Destroy resources when done
terraform destroy
```

## Example Usage
```bash
# With default values
terraform apply -var-file="dev.tfvars"

# With custom variables
terraform apply -var="vm_name=myvm" -var="location=eastus"
```
