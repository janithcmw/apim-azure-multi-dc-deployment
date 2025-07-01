#!/bin/bash
# Current location and the file structure.
echo "The script 'helm-undeploy.sh' will be executed inside the path: " && pwd

#Handing resource names.
resourceGroup=$(echo "rg-$customer_project-cst-multi-dc-westeurope")
aksCluster_1=$(echo "aks-$customer_project-cst-multi-dc-westeurope-001")
aksCluster_2=$(echo "aks-$customer_project-cst-multi-dc-westeurope-002")

#login into cluster1
az aks get-credentials --resource-group "$resourceGroup" --name "$aksCluster_1" --overwrite-existing --admin
sudo kubelogin convert-kubeconfig -l azurecli

#uninstall in dc-1
#uninstall nginx in dc-1
helm uninstall ingress-nginx
kubectl delete -f ./apim-321-fully-distributed-multi-dc/dc-1/ingress/certificate/apim-321-multi-dc-aks-am-ingress-cert.yaml

#uninstall cluster in dc-1
helm uninstall apim-321-multi-dc-aks
kubectl get pods --namespace default

#login into cluster2
az aks get-credentials --resource-group "$resourceGroup" --name "$aksCluster_2" --overwrite-existing --admin
sudo kubelogin convert-kubeconfig -l azurecli

#uninstall in dc-2
#uninstall nginx in dc-2
helm uninstall ingress-nginx
kubectl delete -f ./apim-321-fully-distributed-multi-dc/dc-2/ingress/certificate/apim-321-multi-dc-aks-am-ingress-cert.yaml

#uninstall cluster in dc-2
helm uninstall apim-321-multi-dc-aks
kubectl get pods --namespace default

#verify successful clean up.
bash $(pwd)/wait-for-helm-cleanup.sh ingress-nginx
bash $(pwd)/wait-for-helm-cleanup.sh default

#login into cluster1
az aks get-credentials --resource-group "$resourceGroup" --name "$aksCluster_1" --overwrite-existing --admin
sudo kubelogin convert-kubeconfig -l azurecli

#verify successful clean up.
bash $(pwd)/wait-for-helm-cleanup.sh ingress-nginx
bash $(pwd)/wait-for-helm-cleanup.sh default

echo "Helm resources undeployed successfully!!!"