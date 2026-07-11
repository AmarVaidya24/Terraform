# Terraform

Terraform Course

## Prerequisites

**Important:** Before running Terraform commands, ensure you have your **Azure Subscription ID** configured. You can provide it in the following ways:

1. **Set as Environment Variable:**

   ```powershell
   $env:ARM_SUBSCRIPTION_ID = "your-subscription-id"
   ```

2. **Configure in Provider Block:**

   ```hcl
   provider "azurerm" {
     features {}
     subscription_id = "your-subscription-id"
   }
   ```

3. **Use Azure CLI:**
   ```powershell
   az account set --subscription "your-subscription-id"
   ```

---

## Course Structure - Day Wise Folder Details

### **Day 1: Introduction & Setup**

- **Location:** `Day1/`
- **Topics Covered:**
  - Introduction to Terraform
  - Installation guide
  - Getting started with Terraform
  - Basic Terraform configuration (`main.tf`)
  - State file management
- **PowerShell Scripts:**
  - `powershellScriptToCreateResource.ps1` - Script to create resources
  - `Vnet-udpate.ps1` - Virtual Network update script

### **Day 2: Providers & Variables**

- **Location:** `Day2/`
- **Topics Covered:**
  - Provider configuration
  - Multiple providers setup
  - Multi-region deployments
  - Required providers declaration
  - Variables in Terraform
  - Implementation of variables
  - TFVars file management
  - Conditional expressions
  - Built-in functions
  - Resource creation best practices
- **Key Files:**
  - `06-variables-implementation.tf` - Variable implementation examples
  - `terraform.tfvars` - Variable values file

### **Day 3: Advanced Configuration**

- **Location:** `Day3/`
- **Topics Covered:**
  - Advanced Terraform configurations
  - State file management
- **Files:**
  - `Main.tf` - Main configuration file

### **Day 4: Configuration & State Management**

- **Location:** `Day4/`
- **Topics Covered:**
  - Complex configurations
  - State file handling
- **Files:**
  - `main.tf` - Primary configuration

### **Day 5: Advanced Topics & Real-World Scenarios**

- **Location:** `Day5/`
- **Sub-sections:**

  #### **00 - Basics**
  - Basic Terraform setup
  - Development environment configuration
  - Files: `main.tf`, `dev.tfvars`

  #### **00 - Functions in Terraform**
  - **lookup function** - Example in `Example - lookup/main.tf`
  - **coalesce function** - Example in `Example- coalesce/main.tf`
  - **merge function** - Example in `Example- Merge/main.tf`
  - **try function** - Example in `Example-tryFunction/main.tf`
  - **Other functions** - Example in `Example-otherfunctions/main.tf`

  #### **01 - Count in Terraform**
  - `Example1 -use count/` - Basic count usage
  - `Example2- using count with a variable/` - Count with variables
  - `Example3- count index/` - Using count.index
  - `Example4 -conditional count/` - Conditional count expressions

  #### **02 - Looping in Terraform**
  - Advanced looping techniques and patterns

  #### **03 - Module in Terraform**
  - Module structure and best practices
  - VM module in `modules/vm/` with:
    - `main.tf`, `variables.tf`, `outputs.tf`
  - Environment-specific configs: `dev.tfvars`, `prod.tfvars`
  - `provider.tf` - Provider configuration
  - `outputs.tf` - Output values

  #### **04 - State File in Azure Storage**
  - **Example1/** - Basic backend configuration
    - Remote state setup with `backend.tf`
  - **Example2/** - Multi-environment state management
    - **Env/dev/** - Development environment
      - Backend configuration for dev
      - `dev.tfvars` - Dev-specific variables
    - **Env/prod/** - Production environment
      - Backend configuration for prod
      - `prod.tfvars` - Prod-specific variables
    - **modules/windows-vm/** - Windows VM module
      - Reusable VM module for multiple environments

  #### **05 - Provisioners**
  - Provisioner examples and use cases
  - README with best practices

  #### **azure-hub-spoke**
  - Hub-and-Spoke network architecture
  - Complete example with:
    - `providers.tf` - Provider setup
    - `main.tf` - Hub-Spoke configuration
    - `variables.tf` - Variable definitions
    - `outputs.tf` - Output definitions
    - `terraform.tfvars.example` - Example values
    - `README.md` - Architecture documentation

### **Day 6: Azure Pipelines & CI/CD Deployment**

- **Location:** `Day6/`
- **Topics Covered:**
  - Azure Pipeline configuration for Terraform
  - CI/CD workflow with multiple stages
  - Environment-based deployments (Dev and Prod)
  - Terraform state management in pipeline
  - Security best practices for Terraform in pipelines
- **Key Files:**
  - `providers.tf` - Azure provider configuration
  - `variables.tf` - Input variable definitions
  - `main.tf` - Resource definitions (Resource Group, Storage Account, Container)
  - `outputs.tf` - Output values
  - `terraform.tfvars` - Example variable values
  - `azure-pipelines.yml` - CI/CD pipeline configuration
  - `README.md` - Complete setup and usage guide
- **Pipeline Stages:**
  1. **Validate** - Terraform format and syntax validation
  2. **Plan** - Generate and publish deployment plan
  3. **Deploy to Development** - Automated deployment to dev
  4. **Deploy to Production** - Manual approval gate for production
- **Resources Created:**
  - Azure Resource Group
  - Azure Storage Account
  - Storage Container for blob storage
- **Pipeline Features:**
  - Remote state management using Azure Storage backend
  - Multi-stage deployment with approval gates
  - Artifact publishing for plan review
  - Security best practices (sensitive variables, RBAC)

---

## Getting Started

1. Install Terraform (see `Day1/03-install.md`)
2. Set your Azure subscription ID (see Prerequisites section above)
3. Navigate to the desired day folder
4. Initialize Terraform: `terraform init`
5. Plan deployment: `terraform plan`
6. Apply configuration: `terraform apply`
