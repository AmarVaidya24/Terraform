# Variables
variable "rg_name" {
  description = "Name of the resource group"
  type        = string
}
variable "location" {
  description = "Azure location for resources"
  type        = string
}
variable "vm_name" {
  description = "Name of the Virtual Machine"
  type        = string
}
variable "vm_size" {
  description = "Azure Virtual Machine size"
  type        = string
  default     = "Standard_D2s_v3"
}
variable "admin_username" {
  description = "Admin username for the VM"
  type        = string
  default     = "azureuser"
}
variable "admin_password" {
  description = "Admin password for the VM"
  type        = string
  sensitive   = true
}

variable "os_disk_type" {
  type    = string
  default = "Standard_LRS"
}

variable "hibernation_enabled" {
  type    = bool
  default = false
}
