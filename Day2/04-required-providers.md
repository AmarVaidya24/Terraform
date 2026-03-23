# Provider Configuration

The `required_providers` block in Terraform is used to declare and specify the required provider configurations for your Terraform module or configuration. It allows you to specify the provider name, source, and version constraints.

```
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
}

provider "azurerm" {
  features {}
}

```

# Explanation

The required_providers block ensures that Terraform will download the correct Azure provider (azurerm) from the HashiCorp registry.

The version constraint (~> 3.0) means Terraform will use the latest 3.x release but not upgrade to 4.x automatically.

The provider "azurerm" block initializes the Azure provider and enables its features.

This configuration guarantees that your Terraform project is always using a compatible Azure provider version, making deployments more predictable and stable.
