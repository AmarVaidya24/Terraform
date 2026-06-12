
# This Terraform configuration demonstrates how to use the `for_each` meta-argument to create multiple Azure Resource Groups based on a map variable. Each key in the map represents the name of the resource group, and the corresponding value represents its location.
variable "rgs" {
  type = map(any)
  default = {
    "ResourceGroup1" = "westus"
    "ResourceGroup2" = "eastus"
    "ResourceGroup3" = "centralus"
  }
}

resource "azurerm_resource_group" "rgs" {
  for_each = var.rgs
  name     = each.key
  location = each.value
}


