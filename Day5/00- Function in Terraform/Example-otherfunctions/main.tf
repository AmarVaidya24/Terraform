# terraform function example
# This Terraform configuration demonstrates how to use the `length` function to determine the number of elements in a list variable. The `length` function is used to calculate the number of resource groups defined in the `resource_groups` variable, and this value is outputted as `number_of_resource_groups`.
variable "resource_groups" {
  type    = list(string)
  default = ["rg1", "rg2", "rg3"]
}
output "number_of_resource_groups" {
  value = length(var.resource_groups)
}

# few more examples of functions in terraform
# 1. Using the `upper` function to convert a string to uppercase
output "upper_case_example" {
  value = upper("hello terraform")
}
# 2. Using the `lower` function to convert a string to lowercase
output "lower_case_example" {
  value = lower("HELLO TERRAFORM")
}

# 3. Using the `join` function to concatenate a list of strings into a single string
output "joined_string_example" {
  value = join(", ", var.resource_groups)
}
# 4. Using the `split` function to split a string into a list of strings
output "split_string_example" {
  value = split(", ", "rg1, rg2, rg3")
}
# 5. Using the `length` function to get the number of elements in a list
output "length_of_resource_groups" {
  value = length(var.resource_groups)
}
# 6. Using the `contains` function to check if a list contains a specific value
output "contains_example" {
  value = contains(var.resource_groups, "rg2")
}
# 7. Using the `max` function to get the maximum value from a list of numbers
output "max_example" {
  value = max([1, 2, 3, 4, 5])
}
# 8. Using the `min` function to get the minimum value from a list of numbers
output "min_example" {
  value = min([1, 2, 3, 4, 5])
}
# 9. Using the `concat` function to concatenate two lists into a single list
output "concat_example" {
  value = concat(["rg1", "rg2"], ["rg3", "rg4"])
}
# 10. Using the `distinct` function to remove duplicate values from a list
output "distinct_example" {
  value = distinct(["rg1", "rg2", "rg2", "rg3"])
}
