# in Terraform the coalesce function is used to return the first non-null value from a list of arguments. In this example, we have a local variable called "subnets" which contains three subnet values.

locals {
  subnets = {
    subnet1 = null
    subnet2 = null
    subnet3 = "192.168.1.0/24"
  }
}
output "subnet" {
  value = coalesce(local.subnets.subnet1, local.subnets.subnet2, local.subnets.subnet3)
}
