# Providers

A provider in Terraform is a plugin that enables interaction with an API.
This includes cloud providers, SaaS providers, and other APIs. The providers are specified in the Terraform configuration code. They tell Terraform which services it needs to interact with.

For example, if you want to use Terraform to create a virtual machine on Azure, you would need to use the azurerm provider. The azurerm provider provides a set of resources that Terraform can use to create, manage, and destroy resources on Azure.

Here is an example of how to use the azurerm provider in a Terraform configuration:

```hcl
provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "rg" {
  name     = "rg-terraform"
  location = "westeurope"
}

resource "azurerm_virtual_network" "vnet" {
  name                = "vnet-terraform"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}
```

In this example, we are first defining the `azurerm` provider. We then create a resource group and a virtual network in the `westeurope` region. When Terraform runs, it will install the Azure provider and use it to provision these resources.
Here are some other examples of providers:

- `azurerm` - for Azure
- `google` - for Google Cloud Platform
- `kubernetes` - for Kubernetes
- `openstack` - for OpenStack
- `vsphere` - for VMware vSphere

There are many other providers available, and new ones are being added all the time.

Providers are an essential part of Terraform. They allow Terraform to interact with a wide variety of cloud providers and other APIs. This makes Terraform a very versatile tool that can be used to manage a wide variety of infrastructure.

## Different ways to configure providers in terraform

There are three main ways to configure providers in Terraform:

### In the root module

This is the most common way to configure providers. The provider configuration block is placed in the root module of the Terraform configuration. This makes the provider configuration available to all the resources in the configuratio

```hcl
provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "example" {
  name     = "rg-example"
  location = "eastus"
}
```

### In a child module

You can also configure providers in a child module. This is useful if you want to reuse the same provider configuration in multiple resources.

```hcl
module "network" {
  source = "./network"
  providers = {
    azurerm = azurerm.westeurope
  }
}

resource "azurerm_virtual_machine" "example" {
  name                  = "vm-example"
  location              = "westeurope"
  resource_group_name   = module.network.rg_name
  network_interface_ids = [module.network.nic_id]
  vm_size               = "Standard_B1s"
}

```

### In the required_providers block

You can also configure providers in the `required_providers` block. This is useful if you want to make sure that a specific provider version is used.

```hcl
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

The best way to configure providers depends on your specific needs. If you are only using a single provider, then configuring it in the root module is the simplest option. If you are using multiple providers, or if you want to reuse the same provider configuration in multiple resources, then configuring it in a child module is a good option. And if you want to make sure that a specific provider version is used, then configuring it in the required_providers block is the best option.
