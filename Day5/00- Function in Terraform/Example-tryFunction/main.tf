# Try block example in Terraform.
# This Terraform configuration demonstrates how to use the `try` function to handle potential errors when accessing a non-existent key in a map variable. The `try` function attempts to access the value of the key "non_existent_key" in the `example_map` variable. If the key does not exist, it returns a default value of "default_value" instead of throwing an error.
variable "example_map" {
  type = map(string)
  default = {
    key1 = "value1"
    key2 = "value2"
  }
}

output "try_example" {
  value = try(var.example_map["non_existent_key"], "default_value")
  #value = var.example_map["key3"] # This will throw an error because key3 does not exist in the map
}

# another Example of try block in terraform
locals {
  subnets = {
    subnet1 = "192.168.0.0/24"
    subnet2 = "192.168.1.0/24"
  }
}

output "subnet1_cidr" {
  value = try(local.subnets.subnet3, local.subnets.subnet2)
}



