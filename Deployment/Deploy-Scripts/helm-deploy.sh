# Current location and the file structure.
echo "The script 'helm-deploy.sh' will be executed inside the path: " && pwd
echo "Existing files in the Helm build location." && tree

#login into cluster1
az aks get-credentials --resource-group rg-multi-dc-cst-env-westeurope --name aks-multi-dc-cst-env-westeurope-001 --overwrite-existing --admin
sudo kubelogin convert-kubeconfig -l azurecli

#create secret to access the docker repository.
kubectl create secret docker-registry janithcmw-secret --docker-username=janithcmw --docker-password=dckr_pat_e67k076xwws2VucQVtc3oCNCSvQ --docker-email=janithcmw@gmail.com

#install dc-1
helm install apim-321-multi-dc-aks ./apim-321-fully-distributed-multi-dc/dc-1
kubectl get pods --namespace default

#login into cluster2
az aks get-credentials --resource-group rg-multi-dc-cst-env-westeurope --name aks-multi-dc-cst-env-westeurope-002 --overwrite-existing --admin
sudo kubelogin convert-kubeconfig -l azurecli

#create secret to access the docker repository.
kubectl create secret docker-registry janithcmw-secret --docker-username=janithcmw --docker-password=dckr_pat_e67k076xwws2VucQVtc3oCNCSvQ --docker-email=janithcmw@gmail.com

#install dc-2
helm install apim-321-multi-dc-aks ./apim-321-fully-distributed-multi-dc/dc-2
kubectl get pods --namespace default

echo "Deployment executed successfully!!!"