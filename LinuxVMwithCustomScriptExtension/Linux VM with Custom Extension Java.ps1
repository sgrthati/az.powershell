﻿$RG = "SRI"
$SUBNET1 = "SRI_SUBNET_1"
$VNET = "SRI_VNET"
$AVAILABILITYSET = "SRI_AVAILABILITY_SET"
$VM = "SRIVM"
$Count= "1"
$location = "CentralIndia"
$Settings = '{"fileUris": ["https://raw.githubusercontent.com/thatisagar/az.powershell/main/LinuxVMwithCustomScriptExtension/java.sh"],"commandToExecute": "sh java.sh"}'

#Resource Group Creation

new-azresourcegroup -Name $RG -location "$location"

#Vnet with Single subnet creation

$SN1 = New-AzVirtualNetworkSubnetConfig -name $SUBNET1 -AddressPrefix "10.0.2.0/24"
New-AzVirtualNetwork -name "$VNET" -ResourceGroupName "$RG" -Location "$location" -AddressPrefix "10.0.0.0/16" -subnet $SN1
$PIP = New-AzPublicIpAddress -Name "PIP$i" -ResourceGroupName "$RG" -Location "$location" -AllocationMethod Static -IpAddressVersion IPv4

#Availability Set Creation

New-AzAvailabilitySet   -Location "$location"   -Name $AVAILABILITYSET  -ResourceGroupName "$RG"   -Sku aligned  -PlatformFaultDomainCount 2 -PlatformUpdateDomainCount 2


#For Multiple VM Creation

for ($i=1; $i -le $Count; $i++)
{
$VMLocalAdminUser = "sagar"
$VMLocalAdminSecurePassword = ConvertTo-SecureString "Sagar@123456" -AsplainText -Force
$Credential = New-Object System.Management.Automation.PSCredential ($VMLocalAdminUser, $VMLocalAdminSecurePassword)
New-AzVM -ResourceGroupName "$RG" -Name "$VM$i" -location "$location" -Image "UbuntuLTS" -VirtualNetworkName "$VNET" -Subnetname "$SUBNET1" -Credential $Credential -Size "Standard_DS1_v2" -AvailabilitySetName "$AVAILABILITYSET" -PublicIpAddressName "PIP$i"
Set-AzVMExtension -Name 'CustomScript' -ExtensionType 'CustomScriptForLinux' -ResourceGroupName $RG -VM  $VM$i -Publisher 'Microsoft.OSTCExtensions' -SettingString $Settings -TypeHandlerVersion '1.1'
} 
