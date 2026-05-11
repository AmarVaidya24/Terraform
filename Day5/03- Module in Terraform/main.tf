module "windows_vm" {
  source              = "./modules/vm"
  rg_name             = var.rg_name
  location            = var.location
  vm_name             = var.vm_name
  vm_size             = var.vm_size
  admin_username      = var.admin_username
  admin_password      = var.admin_password
  os_disk_type        = var.os_disk_type
  hibernation_enabled = var.hibernation_enabled
}

# run like this: terraform apply -var-file="dev.tfvars"
# for prod: terraform apply -var-file="prod.tfvars"
