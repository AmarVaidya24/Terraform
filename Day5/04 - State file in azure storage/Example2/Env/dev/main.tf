# for Dev environment
# cd Env/dev
# terraform init
# terraform apply -var-file=dev.tfvars

provider "azurerm" {
  features {}
}

module "windows_vm" {
  source = "../../modules/windows-vm"

  rg_name             = var.rg_name
  location            = var.location
  vm_name             = var.vm_name
  vm_size             = var.vm_size
  admin_username      = var.admin_username
  admin_password      = var.admin_password
  os_disk_type        = var.os_disk_type
  hibernation_enabled = var.hibernation_enabled
}
