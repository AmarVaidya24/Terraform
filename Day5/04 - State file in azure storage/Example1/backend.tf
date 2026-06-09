terraform {
  backend "azurerm" {
    resource_group_name  = "rg-tf-backend"
    storage_account_name = "sttfbackend123"    # Replace with your storage account name
    container_name       = "tfstate"           # Replace with your container name
    key                  = "example1.tfstate"  # State file name in the container
  }
}
