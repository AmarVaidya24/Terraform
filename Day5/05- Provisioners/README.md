# Terraform Provisioners Example

This directory contains a basic example of Terraform provisioners in Azure.

## Resources Created

| Resource | Name | Location |
|----------|------|----------|
| Resource Group | rg-example | centralindia |
| Virtual Network | vnet-example | centralindia |

## What are Provisioners?

Provisioners in Terraform are used to execute scripts or commands on local or remote machines after a resource is created. They allow you to:

- Run configuration scripts on newly created resources
- Execute commands on the machine running Terraform (local-exec)
- Run commands on the target resource after it's created (remote-exec)

## Types of Provisioners

### 1. local-exec

- Runs on the machine where Terraform is executed
- Useful for printing information, calling APIs, or running local scripts
- Example: Logging, notifications, triggering external workflows

```hcl
provisioner "local-exec" {
  interpreter = ["PowerShell", "-Command"]
  command     = "Write-Host \"Message here\""
}
```

### 2. remote-exec

- Runs on the target resource after it's created
- Requires connection to the remote machine (typically via SSH or WinRM)
- Useful for configuring servers, installing software, running setup scripts

## Key Differences

| local-exec | remote-exec |
|------------|-------------|
| Runs on Terraform machine | Runs on target resource |
| No connection required | Requires connection config |
| For local operations | For remote configuration |

## Note

Provisioners should be used as a last resort in Terraform. For most use cases, consider:
- Using cloud-init for VM initialization
- Using configuration management tools (Ansible, Chef, Puppet)
- Using ARM templates or cloud-specific configuration

## Usage

```bash
terraform init
terraform plan
terraform apply
```

## Outputs vs Provisioners

- **Outputs**: Display values after Terraform execution
- **Provisioners**: Execute scripts/commands after resource creation

These are two different concepts - outputs are for displaying values, while provisioners are for running actions.