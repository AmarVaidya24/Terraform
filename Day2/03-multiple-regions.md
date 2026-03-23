# Multiple Region Implementation in Terraform

You can make use of `alias` keyword to implement multi region infrastructure setup in
terraform. this allows you to deploy resources across different Azure regions within the same project.

```hcl
provider "azurerm" {
  alias           = "eastus"
  features {}
  subscription_id = "your-azure-subscription-id"
  tenant_id       = "your-azure-tenant-id"
}

provider "azurerm" {
  alias           = "westeurope"
  features {}
  subscription_id = "your-azure-subscription-id"
  tenant_id       = "your-azure-tenant-id"
}

resource "azurerm_resource_group" "rg_eastus" {
  name     = "rg-eastus"
  location = "eastus"
  provider = azurerm.eastus
}

resource "azurerm_resource_group" "rg_westeurope" {
  name     = "rg-westeurope"
  location = "westeurope"
  provider = azurerm.westeurope
}

```

# Explanation

Two providers are defined: one for `East US` and one for `West Europe`, each with an alias.

Resources are then created in different regions by referencing the appropriate provider alias.

This approach is useful when you want to deploy redundant infrastructure across multiple Azure regions for high availability or disaster recovery.
