
$resouceGroup= "NewTerraform"
$vnetName="VirtualNetwork"
$newsubnetName="subnet2"
$newsubnetPrefix ="10.0.1.0/24"

$vnet = Get-AzVirtualNetwork -Name $vnetName -ResourceGroupName $resouceGroup

Add-AzVirtualNetworkSubnetConfig -Name $newsubnetName -AddressPrefix $newsubnetPrefix -VirtualNetwork $vnet

$vnet | Set-AzVirtualNetwork

8a566038-6a0a-478b-8291-25d5692f815a