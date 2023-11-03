$PRE = "SRI2"
$location = "CentralIndia"
$RG = "${PRE}-RG"
$SUBNET1 = "${PRE}_SUBNET_1"
$VNET = "${PRE}_VNET"
$VM = "${RG}-VM"
$Count= "3"
$AVAILABILITYSET = "SRI_AVAILABILITY_SET"

#Resource Group Creation

new-azresourcegroup -Name $RG -location "$location"

#Vnet with Single subnet creation

$SN1 = New-AzVirtualNetworkSubnetConfig -name $SUBNET1 -AddressPrefix "10.0.2.0/24"
New-AzVirtualNetwork -name "$VNET" -ResourceGroupName "$RG" -Location "$location" -AddressPrefix "10.0.0.0/16" -subnet $SN1
New-AzPublicIpAddress -Name "PIP$i" -ResourceGroupName "$RG" -Location "$location" -AllocationMethod Static -IpAddressVersion IPv4

#Availability Set Creation

New-AzAvailabilitySet   -Location "$location"   -Name $AVAILABILITYSET  -ResourceGroupName "$RG"   -Sku aligned  -PlatformFaultDomainCount 2 -PlatformUpdateDomainCount 2

#For Multiple VM Creation

for ($i=1; $i -le $Count; $i++)
{
$VMLocalAdminUser = "sagar"
$VMLocalAdminSecurePassword = ConvertTo-SecureString "Sagar@123456" -AsplainText -Force
$Credential = New-Object System.Management.Automation.PSCredential ($VMLocalAdminUser, $VMLocalAdminSecurePassword)
New-AzPublicIpAddress -Name "PIP$i" -ResourceGroupName "$RG" -Location "$location" -AllocationMethod Static -IpAddressVersion IPv4
New-AzVM -ResourceGroupName "$RG" -Name "$VM-$i" -Image "Win2022AzureEditionCore" -location "$location" -VirtualNetworkName "$VNET" -Subnetname "$SUBNET1" -Credential $Credential -Size "Standard_DS1_v2" -AvailabilitySetName "$AVAILABILITYSET" -PublicIpAddressName "PIP$i" -SecurityType "Standard" -OpenPorts 8080,3389,80
#to run custom script resided in storage account
Set-AzVMCustomScriptExtension -Name "test" -Location "$location" -ResourceGroupName "$RG" -VMName "$VM-$i" -StorageAccountName '<storage account name>' -ContainerName '<contqainer name>' -FileName '<File Name>' -StorageAccountKey '<Storage account security key>' -Run '<file name>'
#to install windows IIS
$PublicSettings = '{"commandToExecute":"powershell Add-WindowsFeature Web-Server -IncludeManagementTools"}'
Set-AzVMExtension -ResourceGroupName "$RG" -ExtensionName "IIS" -VMName "$VM$i" -Location "$location" -Publisher "Microsoft.Compute" -ExtensionType "CustomScriptExtension" -TypeHandlerVersion "1.4" -SettingString $PublicSettings
} 
