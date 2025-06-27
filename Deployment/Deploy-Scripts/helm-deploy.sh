# Current location and the file structure.
echo "The script 'helm-deploy.sh' will be executed inside the path: " && pwd
echo "Existing files in the Helm build location." && tree

#TODO need to use the env variable and pass the image details during the installation.

#login into cluster1
az aks get-credentials --resource-group rg-multi-dc-cst-env-westeurope --name aks-multi-dc-cst-env-westeurope-001 --overwrite-existing --admin
sudo kubelogin convert-kubeconfig -l azurecli

#create secret to access the docker repository.
kubectl create secret docker-registry janithcmw-secret --docker-username=janithcmw --docker-password=dckr_pat_e67k076xwws2VucQVtc3oCNCSvQ --docker-email=janithcmw@gmail.com

#install in dc-1
#install nginx in dc-1
helm upgrade --install ingress-nginx ingress-nginx --repo https://kubernetes.github.io/ingress-nginx --namespace ingress-nginx --create-namespace -f ./apim-321-fully-distributed-multi-dc/dc-1/ingress/apim-321-multi-dc-aks-am-internal-ingress-controller.yaml
kubectl apply -f ./apim-321-fully-distributed-multi-dc/dc-1/ingress/certificate/apim-321-multi-dc-aks-am-ingress-cert.yaml

#install cluster in dc-1
helm install apim-321-multi-dc-aks ./apim-321-fully-distributed-multi-dc/dc-1
kubectl get pods --namespace default

#login into cluster2
az aks get-credentials --resource-group rg-multi-dc-cst-env-westeurope --name aks-multi-dc-cst-env-westeurope-002 --overwrite-existing --admin
sudo kubelogin convert-kubeconfig -l azurecli

#create secret to access the docker repository.
kubectl create secret docker-registry janithcmw-secret --docker-username=janithcmw --docker-password=dckr_pat_e67k076xwws2VucQVtc3oCNCSvQ --docker-email=janithcmw@gmail.com

#install dc-2
#install nginx in dc-2
helm upgrade --install ingress-nginx ingress-nginx --repo https://kubernetes.github.io/ingress-nginx --namespace ingress-nginx --create-namespace -f ./apim-321-fully-distributed-multi-dc/dc-2/ingress/apim-321-multi-dc-aks-am-internal-ingress-controller.yaml
kubectl apply -f ./apim-321-fully-distributed-multi-dc/dc-2/ingress/certificate/apim-321-multi-dc-aks-am-ingress-cert.yaml

#install cluster in dc-2
helm install apim-321-multi-dc-aks ./apim-321-fully-distributed-multi-dc/dc-2
kubectl get pods --namespace default

echo "Deployment executed successfully!!!"