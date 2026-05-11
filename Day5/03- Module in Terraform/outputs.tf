output "vm_id" {
  description = "The ID of the created Virtual Machine"
  value       = module.windows_vm.vm_id
}
output "vm_name" {
  description = "The name of the created Virtual Machine"
  value       = module.windows_vm.vm_name
}
output "vm_location" {
  description = "The location of the created Virtual Machine"
  value       = module.windows_vm.vm_location
}
output "vm_size" {
  description = "The size of the created Virtual Machine"
  value       = module.windows_vm.vm_size
}
output "vnet_name" {
  description = "The name of the virtual network"
  value       = module.windows_vm.vnet_name
}
output "nic_name" {
  description = "The name of the network interface"
  value       = module.windows_vm.nic_name
}
