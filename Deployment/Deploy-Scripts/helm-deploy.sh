# Current location and the file structure.
echo "The script 'helm-deploy.sh' will be executed inside the path: " && pwd
echo "Existing files in the Helm build location." && tree

#Building image details based on 'helm_override_value_string'
echo "Incoming 'helm_override_value_string' is: $helm_override_value_string"
imageRepo=$(echo "$helm_override_value_string" | cut -d'=' -f2)
echo "Captured 'imageRepo' is: $imageRepo"
imageTag=$(echo "$imageRepo" | grep -oP '\d+$')
echo "Captured 'imageTag' is: $imageTag"

#Handing resource names.
resourceGroup=$(echo "rg-$customer_project-cst-multi-dc-westeurope")
aksCluster_1=$(echo "aks-$customer_project-cst-multi-dc-westeurope-001")
aksCluster_2=$(echo "aks-$customer_project-cst-multi-dc-westeurope-002")


#login into cluster1
az aks get-credentials --resource-group "$resourceGroup" --name "$aksCluster_1" --overwrite-existing --admin
sudo kubelogin convert-kubeconfig -l azurecli

#install in dc-1
#install nginx in dc-1
helm upgrade --install ingress-nginx ingress-nginx \
      --repo https://kubernetes.github.io/ingress-nginx \
      --namespace ingress-nginx \
      --create-namespace \
      -f ./apim-321-fully-distributed-multi-dc/dc-1/ingress/apim-321-multi-dc-aks-am-internal-ingress-controller.yaml \
      --set-string controller.service.annotations."service\.beta\.kubernetes\.io/azure-load-balancer-internal-subnet"="snet-vnet-$customer_project-cst-multi-dc-westeurope-001-loadbalancer"
kubectl apply -f ./apim-321-fully-distributed-multi-dc/dc-1/ingress/certificate/apim-321-multi-dc-aks-am-ingress-cert.yaml

#install cluster in dc-1
helm install apim-321-multi-dc-aks ./apim-321-fully-distributed-multi-dc/dc-1 \
      --set wso2.deployment.am.image.repository="$imageRepo" \
      --set wso2.deployment.am.image.tag="$imageTag" \
      --set-string wso2.deployment.services.annotations."service\.beta\.kubernetes\.io/azure-load-balancer-internal-subnet"="cluster1_external_service_subnet"
kubectl get pods --namespace default

#login into cluster2
az aks get-credentials --resource-group "$resourceGroup" --name "$aksCluster_2" --overwrite-existing --admin
sudo kubelogin convert-kubeconfig -l azurecli

#install dc-2
#install nginx in dc-2
helm upgrade --install ingress-nginx ingress-nginx \
      --repo https://kubernetes.github.io/ingress-nginx \
      --namespace ingress-nginx \
      --create-namespace \
      -f ./apim-321-fully-distributed-multi-dc/dc-2/ingress/apim-321-multi-dc-aks-am-internal-ingress-controller.yaml \
      --set-string controller.service.annotations."service\.beta\.kubernetes\.io/azure-load-balancer-internal-subnet"="snet-vnet-$customer_project-cst-multi-dc-westeurope-002-loadbalancer"
kubectl apply -f ./apim-321-fully-distributed-multi-dc/dc-2/ingress/certificate/apim-321-multi-dc-aks-am-ingress-cert.yaml

#install cluster in dc-2
helm install apim-321-multi-dc-aks ./apim-321-fully-distributed-multi-dc/dc-2 \
      --set wso2.deployment.am.image.repository="$imageRepo" \
      --set wso2.deployment.am.image.tag="$imageTag" \
      --set-string wso2.deployment.services.annotations."service\.beta\.kubernetes\.io/azure-load-balancer-internal-subnet"="cluster2_external_service_subnet"
kubectl get pods --namespace default

echo "Deployment executed successfully!!!"