# Day 6: Azure Pipeline & Terraform Deployment

## Overview

This folder demonstrates how to integrate **Terraform** with **Azure Pipelines** for continuous integration and continuous deployment (CI/CD). The example deploys simple Azure resources (Resource Group and Storage Account) across development and production environments.

## Contents

### Terraform Files

- **providers.tf** - Azure provider configuration with subscription ID
- **variables.tf** - Input variables for resource deployment
- **main.tf** - Resource definitions (Resource Group, Storage Account, Container)
- **outputs.tf** - Output values for deployed resources
- **terraform.tfvars** - Example variable values

### Azure Pipeline

- **azure-pipelines.yml** - CI/CD pipeline configuration with multiple stages

## Prerequisites

1. **Azure DevOps Project** - Set up with Git repository
2. **Service Connection** - Create an Azure Resource Manager service connection named `AzureServiceConnection`
3. **Backend Storage** - Create storage account for Terraform state:

   ```powershell
   # Create Resource Group
   az group create --name rg-terraform-state --location "East US"

   # Create Storage Account
   az storage account create `
     --name stterraformstate `
     --resource-group rg-terraform-state `
     --location "East US" `
     --sku Standard_LRS

   # Create Container
   az storage container create `
     --account-name stterraformstate `
     --name tfstate
   ```

## Pipeline Stages

### 1. **Validate Stage**

- Installs Terraform
- Initializes Terraform with remote backend
- Validates Terraform configuration syntax
- Checks code formatting

### 2. **Plan Stage**

- Creates Terraform execution plan
- Publishes plan as artifact for review
- Allows manual approval before apply

### 3. **Deploy to Development**

- Deploys to development environment
- Auto-approval (no manual gate)
- Creates Resource Group and Storage Account

### 4. **Deploy to Production**

- Deploys to production environment
- Requires manual environment approval
- Same infrastructure as dev (can be customized with prod.tfvars)

## Setup Instructions

### Step 1: Update Service Connection

In the pipeline YAML, update the service connection name to match your Azure DevOps setup:

```yaml
backendServiceArm: "AzureServiceConnection" # Update this name
environmentServiceNameAzureRM: "AzureServiceConnection" # Update this name
```

### Step 2: Update Backend Configuration

Replace the backend variables in `azure-pipelines.yml`:

```yaml
backendResourceGroup: "rg-terraform-state" # Your state RG
backendStorageAccount: "stterraformstate" # Your state storage account
backendContainer: "tfstate" # Your state container
backendKey: "day6.tfstate" # Your state file name
```

### Step 3: Update terraform.tfvars

Update `terraform.tfvars` with your actual Azure subscription ID and resource names:

```hcl
subscription_id = "YOUR_ACTUAL_SUBSCRIPTION_ID"
storage_account_name = "stuniquename123"  # Must be globally unique
```

### Step 4: Create Pipeline in Azure DevOps

1. Go to Azure DevOps → Pipelines → New Pipeline
2. Select your repository
3. Choose "Existing Azure Pipelines YAML file"
4. Select `Day6/azure-pipelines.yml`
5. Save and run the pipeline

## Azure DevOps Agent Setup

The pipeline runs on **ubuntu-latest** (Microsoft-hosted agents) by default, but you can use self-hosted agents for more control and customization.

### Option A: Use Microsoft-Hosted Agents (Default - No Setup Required)

The pipeline is configured to use `ubuntu-latest` which is a Microsoft-hosted agent. **No additional setup is needed** - Azure DevOps manages these agents for you.

**Pros:**

- ✅ No setup required
- ✅ Always latest OS and tools
- ✅ No maintenance overhead

**Cons:**

- Limited customization
- Each job starts fresh (slower for large workloads)
- Potential for rate limiting on public IP outbound requests

### Option B: Use Self-Hosted Agent (Optional)

If you need more control or want to run the pipeline on your infrastructure, set up a self-hosted agent:

#### Prerequisites for Self-Hosted Agent

- Windows or Linux machine (with PowerShell installed)
- Network access to Azure DevOps
- Administrator rights to install the agent

#### Step 1: Create Agent Pool

1. Go to **Azure DevOps Project** → **Project Settings** (bottom left)
2. Select **Agent pools** under Pipelines
3. Click **Add pool**
4. Choose Pool type: **Self-hosted**
5. Enter pool name: `terraform-agents` (or your preferred name)
6. Click **Create**

#### Step 2: Download and Install Agent

**Windows PowerShell (as Administrator):**

```powershell
# Create agent directory
mkdir C:\AzureDevOpsAgent
cd C:\AzureDevOpsAgent

# Download agent (replace the URL with the latest version)
Invoke-WebRequest -Uri "https://vstsagentpackage.azureedge.net/agent/3.227.2/vsts-agent-win-x64-3.227.2.zip" -OutFile "vsts-agent-win-x64.zip"

# Extract agent
Expand-Archive -Path "vsts-agent-win-x64.zip" -DestinationPath "."

# Configure agent
.\config.cmd --url https://dev.azure.com/YOUR_ORG --auth pat --token YOUR_PAT
```

**Linux/Ubuntu:**

```bash
# Create agent directory
mkdir ~/myagent
cd ~/myagent

# Download agent
wget https://vstsagentpackage.azureedge.net/agent/3.227.2/vsts-agent-linux-x64-3.227.2.tar.gz

# Extract agent
tar zxvf vsts-agent-linux-x64-3.227.2.tar.gz

# Configure agent
./config.sh --url https://dev.azure.com/YOUR_ORG --auth pat --token YOUR_PAT
```

**Replace:**

- `YOUR_ORG` - Your Azure DevOps organization name
- `YOUR_PAT` - Personal Access Token (see next step)

#### Step 3: Create Personal Access Token (PAT)

1. Go to **Azure DevOps** → **User Settings** (top right) → **Personal access tokens**
2. Click **New Token**
3. Configure:
   - **Name:** `terraform-agent-token`
   - **Organization:** Your organization
   - **Scopes:** Select `Agent Pools (read, manage)` and `Deployment group (read, manage)`
   - **Expiration:** Set appropriate duration
4. Click **Create**
5. Copy the token (appears only once)

#### Step 4: Run Agent

**Windows:**

```powershell
# Run agent once
.\run.cmd

# Or install as Windows Service for continuous operation
.\config.cmd --url https://dev.azure.com/YOUR_ORG --auth pat --token YOUR_PAT --runAsService
```

**Linux:**

```bash
# Run agent once
./run.sh

# Or install as systemd service
sudo ./svc.sh install
sudo ./svc.sh start
```

#### Step 5: Update Pipeline to Use Self-Hosted Agent

In `azure-pipelines.yml`, replace:

```yaml
pool:
  vmImage: "ubuntu-latest"
```

With:

```yaml
pool:
  name: "terraform-agents" # Your agent pool name
```

### Create Service Connection for Authentication

1. Go to **Project Settings** → **Service connections** → **New service connection**
2. Select **Azure Resource Manager**
3. Choose authentication method: **Service Principal (automatic)**
4. Fill in:
   - **Azure subscription:** Select your subscription
   - **Resource group:** (optional)
   - **Service connection name:** `AzureServiceConnection` (must match pipeline YAML)
5. Click **Save**

**Alternative - Manual Service Principal:**

If you need more control:

1. Choose **Service Principal (manual)**
2. Create service principal in Azure:
   ```powershell
   az ad sp create-for-rbac --name terraform-pipeline --role Contributor
   ```
3. Fill in the service principal details in Azure DevOps
4. Assign required RBAC role to the service principal

### Create Environments for Approvals

1. Go to **Pipelines** → **Environments**
2. Click **Create environment**
3. Create two environments:
   - **development** - No approval needed
   - **production** - Add approvers

For production environment:

1. Click **Approvals and checks** (gear icon)
2. Click **Create** → **Approvals**
3. Add users who can approve production deployments
4. Set approval timeout (e.g., 30 days)

### Verify Agent is Ready

1. Go to **Project Settings** → **Agent pools**
2. Select your agent pool
3. Verify agent shows as **Online** (green status)

If offline, check:

- Agent logs: `_diag/` folder in agent directory
- Network connectivity to dev.azure.com
- Firewall rules

## Local Development

### Initialize Terraform

```powershell
cd Day6
terraform init -backend-config="resource_group_name=rg-terraform-state" `
               -backend-config="storage_account_name=stterraformstate" `
               -backend-config="container_name=tfstate" `
               -backend-config="key=day6.tfstate"
```

### Plan Deployment

```powershell
terraform plan -var-file=terraform.tfvars -out=tfplan
```

### Apply Configuration

```powershell
terraform apply tfplan
```

### View Outputs

```powershell
terraform output
```

### Destroy Resources

```powershell
terraform destroy -var-file=terraform.tfvars
```

## Variables Explained

| Variable                           | Default           | Description                           |
| ---------------------------------- | ----------------- | ------------------------------------- |
| `subscription_id`                  | Required          | Azure Subscription ID                 |
| `resource_group_name`              | rg-terraform-demo | Name of resource group                |
| `location`                         | East US           | Azure region                          |
| `storage_account_name`             | stterraformdemo   | Storage account name (must be unique) |
| `storage_account_tier`             | Standard          | Storage tier (Standard/Premium)       |
| `storage_account_replication_type` | LRS               | Replication type (LRS/GRS/RAGRS)      |
| `environment`                      | dev               | Environment name                      |
| `tags`                             | See tfvars        | Resource tags                         |

## Resources Created

1. **Resource Group** - Container for all resources
2. **Storage Account** - Azure blob storage
3. **Storage Container** - Private blob container within storage account

## Security Best Practices

1. ✅ **State File Management** - Stored securely in Azure Storage with access control
2. ✅ **Sensitive Variables** - Subscription ID marked as sensitive in variables
3. ✅ **Environment Separation** - Dev and Prod environments with approval gates
4. ✅ **Service Connection** - Uses managed identity for authentication
5. ✅ **tfvars Management** - Example file committed, actual secrets in Azure DevOps variables

## Troubleshooting

### Pipeline Fails with Backend Error

- Verify backend storage account exists
- Check service connection permissions
- Ensure RBAC role includes storage container access

### Terraform Plan Shows Unexpected Changes

- Run `terraform refresh` to sync state
- Check for out-of-band changes in Azure Portal
- Verify variable values in terraform.tfvars

### Storage Account Name Conflicts

- Storage account names must be globally unique
- Update `storage_account_name` in terraform.tfvars with a unique name
- Run `terraform plan` to verify before apply

## Next Steps

- Add more Azure resources (VNets, VMs, databases)
- Implement module-based architecture
- Add environment-specific configurations with workspace
- Integrate with Terraform Cloud for team collaboration
- Add cost estimation with Infracost
