terraform {
  backend "azurerm" {
    resource_group_name  = "rg-tf-backend"
    storage_account_name = "sttfbackend123"
    container_name       = "tfstate"
    key                  = "prod/windows-vm.tfstate"
  }
}
