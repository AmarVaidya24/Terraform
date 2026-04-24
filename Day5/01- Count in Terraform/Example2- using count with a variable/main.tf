# example of using count with a variable to create multiple resources
variable "rg_count" {
  type    = number
  default = 3
}

# Below example will create 3 resource groups with names ResourceGroup3-1, ResourceGroup3-2, and ResourceGroup3-3
resource "azurerm_resource_group" "rg5" {
  count    = var.rg_count
  name     = "ResourceGroup3-${count.index + 1}"
  location = "westus"
}

# how to referrence the resources created with count
output "rg2_names" {
  value = [for i in azurerm_resource_group.rg5 : i.name]
}



