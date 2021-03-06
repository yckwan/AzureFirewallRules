###Run this if not install Az module##############################################################################################################################################
###Invoke-WebRequest -Uri https://aka.ms/installazurecliwindows -OutFile .\AzureCLI.msi; Start-Process msiexec.exe -Wait -ArgumentList '/I AzureCLI.msi /quiet'; rm .\AzureCLI.msi
###az extension add -n azure-firewall###
##################################################################################################################################################################################
$Subscription = "a74bd413-4769-4b0e-80f0-c300bb62cf6e"
$TenantID = "78f4b8d2-0ebe-4840-8d21-6a71466c644f"
$AzureFirewallName = "SEA-SHARED-FE-AF"
$ResourceGroupName = "SEA-SHARED-NETWORK-RG"
$csv = Import-Csv .\FirewallRules.csv
$location = "southeastasia"
az login --allow-no-subscriptions -t $TenantID
az account set -s $Subscription
foreach ($line in $csv) {
$RuleCollectionName = $line.RuleCollectionName
$Priority = $line.Priority
$Action = $line.Action
$RuleName = $line.RuleName
$Protocol = $line.Protocol
$SourceAddresses = $line.SourceAddresses
$DestinationAddresses = $line.DestinationAddresses
$DestinationPorts = $line.DestinationPorts
Write-Host "Creating Rule Collection " -NoNewline -ForegroundColor Red
Write-Host $RuleCollectionName -NoNewline -ForegroundColor Red
Write-Host "..." -ForegroundColor Red
az network firewall network-rule create --collection-name $RuleCollectionName --destination-ports $DestinationPorts --firewall-name $AzureFirewallName --name $RuleName --protocols $Protocol --resource-group $ResourceGroupName --action $Action --destination-addresses $DestinationAddresses --priority $Priority --source-addresses $SourceAddresses --only-show-errors
}
Write-Host "Finish Create all Firewall Rules!" -ForegroundColor Blue
