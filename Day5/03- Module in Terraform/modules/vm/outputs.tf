# Output
output "vm_id" {
  description = "The ID of the created Azure Virtual Machine"
  value       = azurerm_windows_virtual_machine.example_vm.id
}
output "vm_name" {
  description = "The name of the created Azure Virtual Machine"
  value       = azurerm_windows_virtual_machine.example_vm.name
}
output "vm_location" {
  description = "The location of the created Azure Virtual Machine"
  value       = azurerm_windows_virtual_machine.example_vm.location
}
