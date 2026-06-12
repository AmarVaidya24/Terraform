# Remote State with Azure Storage

## Overview
This example demonstrates how to use Azure Storage Blob as a remote backend to store Terraform state files. This enables state sharing across team members and provides state locking.

## Directory Structure
```
Example2/
├── modules/
│   └── windows-vm/      # Reusable VM module
│       ├── main.tf
│       ├── variables.tf
│       └── outputs.tf
├── Env/
│   ├── dev/             # Dev environment
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   ├── dev.tfvars
│   │   └── backend.tf
│   └── prod/            # Prod environment
│       ├── main.tf
│       ├── variables.tf
│       ├── prod.tfvars
│       └── backend.tf
└── Readme.md
```

## Prerequisites
- Azure Storage Account created with container "tfstate"
- Resource group for backend (e.g., rg-tf-backend)

## How to Run

**DEV Environment:**
```bash
cd Env/dev
terraform init
terraform apply -var-file=dev.tfvars
terraform destroy -var-file=dev.tfvars
```

**PROD Environment:**
```bash
cd Env/prod
terraform init
terraform apply -var-file=prod.tfvars
terraform destroy -var-file=prod.tfvars
```

## Variables
Each environment can customize:
- `rg_name` - Resource group name
- `location` - Azure region
- `vm_name` - VM name
- `vm_size` - VM size (default: Standard_D2s_v3)
- `admin_username` - VM admin username
- `admin_password` - VM admin password (sensitive)
- `os_disk_type` - OS disk type (default: Standard_LRS for dev, StandardSSD_LRS for prod)
- `hibernation_enabled` - Enable hibernation (default: false)
