variable "rg_name" {}
variable "location" {}
variable "vm_name" {}
variable "vm_size" {
  default = "Standard_D2s_v3"
}
variable "admin_username" {}
variable "admin_password" {
  sensitive = true
}
variable "os_disk_type" {
  default = "Standard_LRS"
}
variable "hibernation_enabled" {
  default = false
}
