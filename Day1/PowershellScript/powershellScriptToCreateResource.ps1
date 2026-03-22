# https://learn.microsoft.com/en-us/powershell/azure/install-azps-windows?view=azps-15.4.0&tabs=windowspowershell&pivots=windows-psgallery
# to connect azure account. 
# Connect-AzAccount -DeviceCode

$resouceGroup= "NewTerraform"
$location="westeurope"
$vnetName="VirtualNetwork"
$subnetName="subnet1"
$addressPrefix ="10.0.0.0/16"
$subnetPrefix ="10.0.0.0/24"

New-AzResourceGroup -Name $resouceGroup -Location $location

#Create the subnet config
$SubnetConfig = New-AzVirtualNetworkSubnetConfig -Name $subnetName -AddressPrefix $addressPrefix

#Create virtual network with subnet
New-AzVirtualNetwork -Name $vnetName -ResourceGroupName $resouceGroup -Location $location -AddressPrefix $addressPrefix -Subnet $SubnetConfig
