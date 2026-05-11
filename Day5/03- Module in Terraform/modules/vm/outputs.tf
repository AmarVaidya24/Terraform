# Output
output "vm_id" {
  description = "The ID of the created Azure Virtual Machine"
  value       = azurerm_windows_virtual_machine.example_vm.id
}
output "vm_name" {
  description = "The name of the created Azure Virtual Machine"
  value       = var.vm_name
}
output "vm_location" {
  description = "The location of the created Azure Virtual Machine"
  value       = azurerm_resource_group.example_rg.location
}
output "vm_size" {
  description = "The size of the created Azure Virtual Machine"
  value       = var.vm_size
}
output "vnet_name" {
  description = "The name of the virtual network"
  value       = azurerm_virtual_network.example_vnet.name
}
output "nic_name" {
  description = "The name of the network interface"
  value       = azurerm_network_interface.example_nic.name
}
