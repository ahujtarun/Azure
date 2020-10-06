param(
[string][Parameter(Mandatory=$true)]$subscriptionID,
[string][Parameter(Mandatory=$true)]$resourceGroup,
[string][Parameter(Mandatory=$true)]$clusterName
)


#login into the account and set the current subscription
Write-Host "Attempt Azure Login.."
#az login
az account set --subscription $subscriptionID

Write-Host "Getting Cluster Service Principal.."
#get the service principal associated with the cluster and reset the credentials
$SP_ID = az aks show --name $clusterName --resource-group $resourceGroup `
  --query servicePrincipalProfile.clientId -o tsv
$SP_SECRET = az ad sp credential reset --name $SP_ID --query password -o tsv

Write-Host "Resetting Service Principal.."
az aks update-credentials --resource-group $resourceGroup --name $clusterName `
 --reset-service-principal --service-principal $SP_ID --client-secret $SP_SECRET