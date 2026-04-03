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

3. In your other Terraform configuration files, you can then use the `aws` and `azurerm` providers to create resources in AWS and Azure, respectively,

```hcl
# Create an EC2 instance in AWS
resource "aws_instance" "example_instance" {
  ami           = "ami-0123456789abcdef0"
  instance_type = "t2.micro"
}

# Create a Resource Group in Azure
resource "azurerm_resource_group" "example_rg" {
  name     = "rg-example"
  location = "eastus"
}

```

# Explanation

The **AWS provider** block configures Terraform to interact with AWS in the `us-east-1` region.

The **Azure provider** block configures Terraform to interact with Azure using your subscription and tenant details.

The configuration then provisions an **EC2 instance in AWS** and a **Resource Group in Azure**.

This approach is useful when you need to orchestrate infrastructure across multiple cloud providers in a single Terraform project.
