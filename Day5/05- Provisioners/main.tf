# Resource Group
resource "azurerm_resource_group" "example_rg" {
  name     = "rg-example"
  location = "centralindia"


}
# Virtual Network
resource "azurerm_virtual_network" "example_vnet" {
  name                = "vnet-example"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.example_rg.location
  resource_group_name = azurerm_resource_group.example_rg.name
  # we can use below provisioner to print the name of the virtual network after it is created
  # the difference between local-exec and remote-exec is that local-exec runs on the machine where terraform is being executed, while remote-exec runs on the target resource after it is created.
  # so we can use local-exec to print the name of the virtual network after it is created, while we can use remote-exec to run a script on the virtual machine after it is created.
  # output and provisioner are two different things, output is used to display the value of a variable after the execution of terraform, while provisioner is used to run a script or command after the creation of a resource.
  provisioner "local-exec" {
    interpreter = ["PowerShell", "-Command"]
    command     = "Write-Host \"Virtual Network created successfully! ${azurerm_virtual_network.example_vnet.name}\""
  }

  # remote-exec provisioner can be used to run a script on the virtual machine after it is created, but in this case we are using it to print the name of the virtual network after it is created, which is not the intended use of remote-exec, but it is just for demonstration purposes.
  # the remote-exec provisioner will run on the machine where terraform is being executed, so it will not have access to the virtual network resource, but it will still print the name of the virtual network after it is created.
  provisioner "remote-exec" {
    inline = [
      "Write-Host \"Virtual Network created successfully! ${azurerm_virtual_network.example_vnet.name}\""
    ]

  }

}
