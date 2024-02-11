# in below script we can able to create multiple VMs with standard format 
#below values you can change as per your requirement

$RG = "CLOUD"
$ADDRESS_SPACE = "10.0.0.0/16"
$SUBNET = "10.0.0.0/24"
$SUBNET1 = "${RG}_SUBNET1"
$VNET = "${RG}_VNET"
$VM = "${RG}VM"
$Count= "2"
$NS = "${RG}_NSG"
$location = "CentralIndia"

#Resource Group Creation

new-azresourcegroup -Name $RG -location $location
 
#Network Security Group Creation

$httprule = New-AzNetworkSecurityRuleConfig -Name "ALLOW_HTTP" -Description "Allow HTTP"-Access "Allow" -Protocol "Tcp" -Direction "Inbound" -Priority "100"   -SourceAddressPrefix "Internet" -SourcePortRange *  -DestinationAddressPrefix *   -DestinationPortRange 80
$httpsrule = New-AzNetworkSecurityRuleConfig -Name "ALLOW_HTTPS" -Description "Allow HTTPS"-Access "Allow" -Protocol "Tcp" -Direction "Inbound" -Priority "110"   -SourceAddressPrefix "Internet" -SourcePortRange *  -DestinationAddressPrefix *   -DestinationPortRange 443
$rdprule = New-AzNetworkSecurityRuleConfig -Name "ALLOW_RDP" -Description "Allow RDP"-Access "Allow" -Protocol "Tcp" -Direction "Inbound" -Priority "120"   -SourceAddressPrefix "Internet" -SourcePortRange *  -DestinationAddressPrefix *   -DestinationPortRange 3389
$nsg = New-AzNetworkSecurityGroup -ResourceGroupName "$RG"   -Location $location -Name "$NS" -SecurityRules $httprule,$httpsrule,$rdprule

#Vnet with Single subnet creation

$SN1 = New-AzVirtualNetworkSubnetConfig -name $SUBNET1 -AddressPrefix $SUBNET -NetworkSecurityGroup $nsg
New-AzVirtualNetwork -name "$VNET" -ResourceGroupName "$RG" -Location $location -AddressPrefix $ADDRESS_SPACE -subnet $SN1 



#For Multiple VM Creation

for ($i=1; $i -le $Count; $i++)
{
$VMLocalAdminUser = "sagar"
$VMLocalAdminSecurePassword = ConvertTo-SecureString "Azure@240024" -AsplainText -Force
$Credential = New-Object System.Management.Automation.PSCredential ($VMLocalAdminUser, $VMLocalAdminSecurePassword)
New-AzVM -ResourceGroupName "$RG" -Name "$VM$i" -location $location -Image "Win2019Datacenter" -VirtualNetworkName "$VNET" -Subnetname "$SUBNET1" -Credential $Credential -Size "Standard_DS1_v2" -SecurityGroupName "$NS" 
}