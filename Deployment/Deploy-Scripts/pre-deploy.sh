#Any executions prior to start deploying the Helm resources.
echo "There is plenty of room to add logic here.."
echo "Helm resources to be deployed..." && tree
echo "Just Echo the variables. $subscription_id, $customer_project"

resourceGroup=$(echo "rg-$customer_project-cst-multi-dc-westeurope")
aksCluster_1=$(echo "aks-$customer_project-cst-multi-dc-westeurope-001")
aksCluster_2=$(echo "aks-$customer_project-cst-multi-dc-westeurope-002")

#Create Azure File share to use between two AKS clusters.
echo "Starting to create Azure Storage Account."
az account set --subscription "$subscription_id"
az storage account create --name aksclustercommonsa --resource-group "$resourceGroup" --location westeurope \
      --sku Standard_LRS --kind StorageV2 --access-tier Hot

echo "Fetching the key of the storage account."
aksclustercommonsakey=$(az storage account keys list --resource-group "$resourceGroup" \
                              --account-name aksclustercommonsa --query "[0].value" --output tsv)

# share for synapse-configs
echo "Start creating shares in the storage."
az storage share create --account-name aksclustercommonsa --name synapse-configs --quota 2 \
      --account-key "$aksclustercommonsakey"

# share for executionplans
az storage share create --account-name aksclustercommonsa --name executionplans --quota 2 \
      --account-key "$aksclustercommonsakey"

# share for eventpublishers
az storage share create --account-name aksclustercommonsa --name eventpublishers --quota 2 \
      --account-key "$aksclustercommonsakey"

# share for eventreceivers
az storage share create --account-name aksclustercommonsa --name eventreceivers --quota 2 \
      --account-key "$aksclustercommonsakey"

# share for eventstreams
az storage share create --account-name aksclustercommonsa --name eventstreams --quota 2 \
      --account-key "$aksclustercommonsakey"

#login into cluster1
echo "Start deploying cluster1 related details."
az aks get-credentials --resource-group "$resourceGroup" --name "$aksCluster_1" --overwrite-existing --admin
sudo kubelogin convert-kubeconfig -l azurecli

#create azure secret inside cluster1
echo "Start creating Azure secret cluster related details."
kubectl delete secret azure-secret -n default --ignore-not-found
kubectl create secret generic azure-secret --from-literal=azurestorageaccountname=aksclustercommonsa \
              --from-literal=azurestorageaccountkey="$aksclustercommonsakey" -n default

#login into cluster2
echo "Start deploying cluster2 related details."
az aks get-credentials --resource-group "$resourceGroup" --name "$aksCluster_2" --overwrite-existing --admin
sudo kubelogin convert-kubeconfig -l azurecli

#create azure secret inside cluster2
echo "Start creating Azure secret cluster related details."
kubectl delete secret azure-secret -n default --ignore-not-found
kubectl create secret generic azure-secret --from-literal=azurestorageaccountname=aksclustercommonsa \
              --from-literal=azurestorageaccountkey="$aksclustercommonsakey" -n default