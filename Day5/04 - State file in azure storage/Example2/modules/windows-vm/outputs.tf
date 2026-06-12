output "vm_id" {
  description = "The ID of the created Virtual Machine"
  value       = azurerm_windows_virtual_machine.this.id
}
output "vm_name" {
  description = "The name of the created Virtual Machine"
  value       = var.vm_name
}
output "vm_size" {
  description = "The size of the created Virtual Machine"
  value       = var.vm_size
}
output "rg_name" {
  description = "The name of the resource group"
  value       = var.rg_name
}
output "location" {
  description = "The location of the resources"
  value       = var.location
}
