# Create Resource Group
resource "azurerm_resource_group" "rg" {
  name     = "${var.resource_group_name}-${var.environment}"
  location = var.location
  tags     = var.tags
}

# Create Storage Account
resource "azurerm_storage_account" "storage" {
  name                     = "${var.storage_account_name}${var.environment}"
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = var.storage_account_tier
  account_replication_type = var.storage_account_replication_type

  tags = var.tags

  depends_on = [azurerm_resource_group.rg]
}

# Create Storage Container
resource "azurerm_storage_container" "container" {
  name                  = "terraform-container"
  storage_account_name  = azurerm_storage_account.storage.name
  container_access_type = "private"
}
