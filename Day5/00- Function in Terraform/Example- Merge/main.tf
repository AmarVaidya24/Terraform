# Merge function in Terraform
# The merge function in Terraform is used to combine multiple maps into a single map. In this example, we have two local variables called "map1" and "map2" which contain key-value pairs. We use the merge function to combine these two maps into a single map called "merged_map".
locals {
  map1 = {
    key1 = "value1"
    key2 = "value2"
  }
  map2 = {
    key3 = "value3"
    key4 = "value4"
  }
}
output "merged_map" {
  value = merge(local.map1, local.map2)
}
