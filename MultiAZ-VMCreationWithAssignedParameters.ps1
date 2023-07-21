# in below script we can able to create multiple VMs with standard format 
#below values you can change as per your requirement

$RG = "SRI"
$SUBNET1 = "SRI_SUBNET_1"
$VNET = "SRI_VNET"
$AVAILABILITYSET = "SRI_AVAILABILITY_SET"
$VM = "SRIVM"
$Count= "2"
$NS = "SRI_NSG"



#Resource Group Creation

new-azresourcegroup -Name $RG -location "eastus"
 
#Network Security Group Creation

$httprule = New-AzNetworkSecurityRuleConfig -Name "ALLOW_HTTP" -Description "Allow HTTP"-Access "Allow" -Protocol "Tcp" -Direction "Inbound" -Priority "100"   -SourceAddressPrefix "Internet" -SourcePortRange *  -DestinationAddressPrefix *   -DestinationPortRange 80
$httpsrule = New-AzNetworkSecurityRuleConfig -Name "ALLOW_HTTPS" -Description "Allow HTTPS"-Access "Allow" -Protocol "Tcp" -Direction "Inbound" -Priority "110"   -SourceAddressPrefix "Internet" -SourcePortRange *  -DestinationAddressPrefix *   -DestinationPortRange 443
$rdprule = New-AzNetworkSecurityRuleConfig -Name "ALLOW_RDP" -Description "Allow RDP"-Access "Allow" -Protocol "Tcp" -Direction "Inbound" -Priority "120"   -SourceAddressPrefix "Internet" -SourcePortRange *  -DestinationAddressPrefix *   -DestinationPortRange 3389
$nsg = New-AzNetworkSecurityGroup -ResourceGroupName "$RG"   -Location "EastUS" -Name "$NS" -SecurityRules $httprule,$httpsrule,$rdprule

#Vnet with Single subnet creation

$SN1 = New-AzVirtualNetworkSubnetConfig -name $SUBNET1 -AddressPrefix "10.0.2.0/24" -NetworkSecurityGroup $nsg
New-AzVirtualNetwork -name "$VNET" -ResourceGroupName "$RG" -Location "eastus" -AddressPrefix "10.0.0.0/16" -subnet $SN1 

#Availability Set Creation

New-AzAvailabilitySet   -Location "EastUS"   -Name $AVAILABILITYSET  -ResourceGroupName "$RG"   -Sku aligned  -PlatformFaultDomainCount 2 -PlatformUpdateDomainCount 2


#For Multiple VM Creation

for ($i=1; $i -le $Count; $i++)
{
$VMLocalAdminUser = "sri"
$VMLocalAdminSecurePassword = ConvertTo-SecureString "Sri@123456" -AsplainText -Force
$Credential = New-Object System.Management.Automation.PSCredential ($VMLocalAdminUser, $VMLocalAdminSecurePassword)
New-AzVM -ResourceGroupName "$RG" -Name "$VM$i" -location "eastus" -Image "Win2019Datacenter" -VirtualNetworkName "$VNET" -Subnetname "$SUBNET1" -Credential $Credential -Size "Standard_DS1_v2" -AvailabilitySetName "$AVAILABILITYSET" -SecurityGroupName "$NS" 
}
