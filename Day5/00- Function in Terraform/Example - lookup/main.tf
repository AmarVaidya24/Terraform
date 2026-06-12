# lookup example in Terraform, the lookup function is used to retrieve a value from a map based on a specified key. In this example, we have a local variable called "my_map" which contains key-value pairs. We use the lookup function to retrieve the value associated with the key "key2" from the map.
locals {
  my_map = {
    key1 = "value1"
    key2 = "value2"
    key3 = "value3"
  }
}
output "value" {
  value = lookup(local.my_map, "key2", "default_value")
}

