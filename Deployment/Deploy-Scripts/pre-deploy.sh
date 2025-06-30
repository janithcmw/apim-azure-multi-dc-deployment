#Any executions prior to start deploying the Helm resources.
echo "There is plenty of room to add logic here.."
echo "Helm resources to be deployed..." && tree
echo "Just Echo the variables. $subscription_id, $customer_project"

resourceGroup=$(echo "rg-$customer_project-cst-multi-dc-westeurope")

#Create Azure File share to use between two AKS clusters.
az account set --subscription "$subscription_id"
az storage account create --name aksClusterCommonSA --resource-group "$resourceGroup" --location westeurope \
      --sku Standard_LRS --kind StorageV2 --access-tier Hot

# share for synapse-configs
az storage share create \
  --account-name aksClusterCommonSA \
  --name synapse-configs \
  --quota 2

# share for executionplans
az storage share create \
  --account-name aksClusterCommonSA \
  --name executionplans \
  --quota 2

# share for eventpublishers
az storage share create \
  --account-name aksClusterCommonSA \
  --name eventpublishers \
  --quota 2

# share for eventreceivers
az storage share create \
  --account-name aksClusterCommonSA \
  --name eventreceivers \
  --quota 2

# share for eventstreams
az storage share create \
  --account-name aksClusterCommonSA \
  --name eventstreams \
  --quota 2

aksClusterCommonSAKey=$(az storage account keys list --resource-group "$resourceGroup" \
                              --account-name aksClusterCommonSA --query "[0].value" --output tsv)

#login into cluster1
az aks get-credentials --resource-group "$resourceGroup" --name "$aksCluster_1" --overwrite-existing --admin
sudo kubelogin convert-kubeconfig -l azurecli

#create azure secret inside cluster1
kubectl create secret generic azure-secret --from-literal=azurestorageaccountname=aksClusterCommonSA \
              --from-literal=azurestorageaccountkey="$aksClusterCommonSAKey" -n default

#login into cluster2
az aks get-credentials --resource-group "$resourceGroup" --name "$aksCluster_2" --overwrite-existing --admin
sudo kubelogin convert-kubeconfig -l azurecli

#create azure secret inside cluster2
kubectl create secret generic azure-secret --from-literal=azurestorageaccountname=aksClusterCommonSA \
              --from-literal=azurestorageaccountkey="$aksClusterCommonSAKey" -n default