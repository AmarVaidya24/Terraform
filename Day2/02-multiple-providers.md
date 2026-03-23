# Multiple Providers

You can use multiple providers in one single terraform project. For example,

1. Create a `providers.tf` file in the root directory of your Terraform project.
2. In the `providers.tf` file, define the AWS and Azure providers. For example:

```hcl
provider "aws" {
  region = "us-east-1"
}

provider "azurerm" {
  subscription_id = "your-azure-subscription-id"
  client_id = "your-azure-client-id"
  client_secret = "your-azure-client-secret"
  tenant_id = "your-azure-tenant-id"
}
```

3. In your other Terraform configuration files, you can then use the aws and azurerm providers to create resources in AWS and Azure, respectively,

```hcl
resource "azurerm_resource_group" "primary_rg" {
  name     = "rg-primary"
  location = "eastus"
}

resource "azurerm_resource_group" "secondary_rg" {
  provider = azurerm.secondary
  name     = "rg-secondary"
  location = "westeurope"
}

```

# Explanation

The first provider block configures the default Azure provider (for subscription 1).

The second provider block uses an alias (`secondary`) to configure another Azure provider (for subscription 2).

When creating resources, you can specify which provider to use with the provider argument.

This approach is useful if you need to manage resources across multiple Azure subscriptions, tenants, or regions within the same Terraform project.
