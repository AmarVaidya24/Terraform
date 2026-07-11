output "resource_group_name" {
  description = "Name of the created resource group"
  value       = azurerm_resource_group.rg.name
}

output "resource_group_id" {
  description = "ID of the created resource group"
  value       = azurerm_resource_group.rg.id
}

output "storage_account_name" {
  description = "Name of the created storage account"
  value       = azurerm_storage_account.storage.name
}

output "storage_account_id" {
  description = "ID of the created storage account"
  value       = azurerm_storage_account.storage.id
}

output "storage_account_primary_blob_endpoint" {
  description = "Primary blob endpoint of the storage account"
  value       = azurerm_storage_account.storage.primary_blob_endpoint
}

output "storage_container_id" {
  description = "ID of the storage container"
  value       = azurerm_storage_container.container.id
}

output "storage_container_name" {
  description = "Name of the storage container"
  value       = azurerm_storage_container.container.name
}
