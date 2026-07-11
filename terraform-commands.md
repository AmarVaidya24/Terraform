# Terraform Commands and Documentation

This reference covers Terraform commands for three levels of users:

- Basic users: common commands for deploying resources
- Intermediate users: workspace, state, variable, and module workflows
- Expert users: troubleshooting, debugging, remote state, import, taint, and advanced lifecycle operations

---

## 1. Basic User Commands

### Login and authentication

```powershell
az login
az account set --subscription "YOUR_SUBSCRIPTION_ID"
```

### Initialize a Terraform project

```powershell
cd Day6
terraform init
```

If you want to skip backend setup for a quick local validation:

```powershell
terraform init -backend=false
```

### Validate configuration

```powershell
terraform validate
```

### Format files

```powershell
terraform fmt -recursive
```

### Plan deployment

```powershell
terraform plan -var-file=terraform.tfvars -out=tfplan
```

### Apply deployment

```powershell
terraform apply tfplan
```

### View outputs

```powershell
terraform output
```

### Destroy resources

```powershell
terraform destroy -var-file=terraform.tfvars
```

---

## 2. Intermediate User Commands

### Use a specific workspace

```powershell
terraform workspace list
terraform workspace new dev
tterraform workspace select dev
```

### Check current state

```powershell
terraform state list
terraform state show azurerm_resource_group.rg
```

### Refresh state from real infrastructure

```powershell
terraform refresh
```

### View plan with detailed changes

```powershell
terraform plan -var-file=terraform.tfvars -out=tfplan -detailed-exitcode
```

### Reinitialize after changing providers or modules

```powershell
terraform init -upgrade
```

### Use variable files and override values

```powershell
terraform plan -var-file=dev.tfvars
terraform apply -var-file=prod.tfvars
```

### Download providers and modules again

```powershell
terraform providers
terraform get -update
```

### Import existing resources into state

```powershell
terraform import azurerm_resource_group.rg /subscriptions/<sub-id>/resourceGroups/my-rg
```

### Show dependency graph

```powershell
terraform graph | dot -Tpng > graph.png
```

---

## 3. Expert User Commands

### Troubleshoot failed deployments

```powershell
terraform plan -refresh-only
terraform refresh
terraform show
terraform show tfplan
```

### Force recreation of a resource

```powershell
terraform taint azurerm_storage_account.storage
terraform apply
```

### Remove taint from a resource

```powershell
terraform untaint azurerm_storage_account.storage
```

### Check what Terraform is about to change

```powershell
terraform plan -out=tfplan
terraform show -json tfplan > plan.json
```

### Debug Terraform execution

```powershell
TF_LOG=DEBUG terraform plan -var-file=terraform.tfvars
```

On Windows PowerShell:

```powershell
$env:TF_LOG="DEBUG"
terraform plan -var-file=terraform.tfvars
```

### Debug provider interactions

```powershell
$env:TF_LOG_CORE="DEBUG"
$env:TF_LOG_PROVIDER="DEBUG"
terraform plan -var-file=terraform.tfvars
```

### Inspect state file content

```powershell
terraform state pull > state.json
```

### Remove a resource from state without deleting it from Azure

```powershell
terraform state rm azurerm_storage_account.storage
```

### Move a resource in state

```powershell
terraform state mv azurerm_resource_group.rg azurerm_resource_group.new_rg
```

### Lock the state file

```powershell
terraform force-unlock <lock-id>
```

### Check Terraform version and providers

```powershell
terraform version
terraform providers
```

---

## 4. Azure-Specific Commands

### Login to Azure

```powershell
az login
```

### Set subscription

```powershell
az account set --subscription "YOUR_SUBSCRIPTION_ID"
```

### Create Azure storage for Terraform backend (if needed)

```powershell
az group create --name rg-terraform-state --location "East US"
az storage account create --name stterraformstate --resource-group rg-terraform-state --location "East US" --sku Standard_LRS
az storage container create --account-name stterraformstate --name tfstate
```

---

## 5. Common Troubleshooting Scenarios

### Scenario 1: Resource already exists

```powershell
terraform plan
terraform import <resource_type>.<name> <resource_id>
```

### Scenario 2: State is out of sync

```powershell
terraform refresh
terraform plan
```

### Scenario 3: Provider version issue

```powershell
terraform init -upgrade
```

### Scenario 4: Lock issue

```powershell
terraform force-unlock <lock-id>
```

### Scenario 5: Resource recreation needed

```powershell
terraform taint <resource>
terraform apply
```

---

## 6. Process to Add an Existing Resource to Terraform

If you already created a resource manually in Azure and want Terraform to manage it, the correct process is:

### Step 1: Make sure the resource already exists in Azure

Verify the resource exists using Azure CLI or the Azure Portal.

```powershell
az resource show --ids "/subscriptions/<sub-id>/resourceGroups/<rg-name>/providers/Microsoft.Storage/storageAccounts/<storage-name>"
```

### Step 2: Add the matching resource block to Terraform configuration

Create or update the Terraform configuration so the resource is described in code.

Example:

```hcl
resource "azurerm_resource_group" "rg" {
  name     = "my-rg"
  location = "East US"
}
```

> Terraform must already be able to understand the provider and resource type for the import to work.

### Step 3: Initialize Terraform if needed

```powershell
terraform init
```

### Step 4: Run Terraform plan before importing

This helps confirm the resource is currently absent from state and will be created from Terraform's perspective.

```powershell
terraform plan
```

### Step 5: Import the existing resource into Terraform state

Use the resource address and the Azure resource ID.

```powershell
terraform import azurerm_resource_group.rg /subscriptions/<sub-id>/resourceGroups/my-rg
```

Important notes:

- The address must match the Terraform resource block name.
- The ID must be the provider-specific resource ID.
- Each remote object should be imported only once to one Terraform address.

### Step 6: Review the imported state

```powershell
terraform state show azurerm_resource_group.rg
```

### Step 7: Run plan again

Terraform should now show no create action for that resource if the configuration matches the existing infrastructure.

```powershell
terraform plan
```

### Step 8: Apply if needed

```powershell
terraform apply
```

### Alternative: Use import blocks for repeatable automation

Newer Terraform workflows can also use `import` blocks directly in configuration so imports can be automated in CI/CD pipelines.

Example:

```hcl
import {
  to = azurerm_resource_group.rg
  id = "/subscriptions/<sub-id>/resourceGroups/my-rg"
}
```

Then run:

```powershell
terraform plan
terraform apply
```

### Common import pitfalls

- Wrong resource address
- Wrong Azure resource ID format
- Importing the same resource twice
- Provider configuration not available during import
- State drift between Terraform config and real Azure resource

---

## 7. Practical Examples

### Example 1: Create a resource group in Azure

```hcl
resource "azurerm_resource_group" "rg" {
  name     = "rg-demo"
  location = "East US"
}
```

```powershell
terraform init
terraform plan -var-file=terraform.tfvars
terraform apply -var-file=terraform.tfvars
```

### Example 2: Import an existing resource group into Terraform state

```hcl
resource "azurerm_resource_group" "rg" {
  name     = "rg-demo"
  location = "East US"
}
```

```powershell
terraform import azurerm_resource_group.rg /subscriptions/<sub-id>/resourceGroups/rg-demo
terraform plan
```

### Example 3: Inspect state for a specific resource

```powershell
terraform state list
terraform state show azurerm_resource_group.rg
```

### Example 4: Recreate a resource if Terraform says it needs replacement

```powershell
terraform taint azurerm_storage_account.storage
terraform apply
```

### Example 5: Troubleshoot a failed deployment

```powershell
terraform plan -refresh-only
terraform refresh
terraform show
```

### Example 6: Debug provider issues

```powershell
$env:TF_LOG="DEBUG"
terraform plan -var-file=terraform.tfvars
```

---

## 8. Best Practices

- Always run `terraform plan` before `terraform apply`.
- Keep `.tfvars` files separate for environment-specific values.
- Never commit secrets directly; use environment variables or Azure DevOps secret variables.
- Use remote state for team collaboration.
- Review the plan carefully before applying changes.
- Use `terraform state` commands carefully because they can affect infrastructure state.
