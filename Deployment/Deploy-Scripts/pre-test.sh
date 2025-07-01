#This script is used to populate the DNS mappings relevant to the tests.
#dc-1
echo -e "10.8.0.111 analytics.dc1.am.wso2.com gateway.dc1.am.wso2.com control.plane.dc1.am.wso2.com traffic.manager.dc1.am.wso2.com key.manager.dc1.am.wso2.com wss.gateway.dc1.am.wso2.com ws.gateway.dc1.am.wso2.com" | sudo tee -a /etc/hosts > /dev/null

#dc-2
echo -e "10.9.0.111 analytics.dc2.am.wso2.com gateway.dc2.am.wso2.com control.plane.dc2.am.wso2.com traffic.manager.dc2.am.wso2.com key.manager.dc2.am.wso2.com wss.gateway.dc2.am.wso2.com ws.gateway.dc2.am.wso2.com" | sudo tee -a /etc/hosts > /dev/null

#TM-Hosts
echo "10.8.4.101 traffic.manager1.external.svc.dc1.am.wso2.com" | sudo tee -a /etc/hosts > /dev/null
echo "10.8.4.102 traffic.manager2.external.svc.dc1.am.wso2.com" | sudo tee -a /etc/hosts > /dev/null
echo "10.9.4.101 traffic.manager1.external.svc.dc2.am.wso2.com" | sudo tee -a /etc/hosts > /dev/null
echo "10.9.4.102 traffic.manager2.external.svc.dc2.am.wso2.com" | sudo tee -a /etc/hosts > /dev/null

#DB-Host
echo "10.8.4.103 mysql.service.am.wso2.com" | sudo tee -a /etc/hosts > /dev/null

resourceGroup=$(echo "rg-$customer_project-cst-multi-dc-westeurope")
aksCluster_1=$(echo "aks-$customer_project-cst-multi-dc-westeurope-001")
aksCluster_2=$(echo "aks-$customer_project-cst-multi-dc-westeurope-002")

#Sleeping
echo "Next 5 minutes the scripts will be sleeping and allowing the k8s setup to be deployed."
sleep 300

#login into cluster1
echo "Login to the  DC1 to capture the hostname."
az aks get-credentials --resource-group $resourceGroup --name $aksCluster_1 --overwrite-existing --admin
sudo kubelogin convert-kubeconfig -l azurecli
#Add GW pod IPs as hosts.
#DC1
echo "The GW pod hostname capturing script will be executed against the DC1"
source $(pwd)/fetch-host-entries.sh apim-321-multi-dc-aks-am-gateway-deployment-1 deployment=apim-321-multi-dc-aks-am-gateway dc1 default
echo -e "$HOST_ENTRIES_ENV" | sudo tee -a /etc/hosts > /dev/null

source $(pwd)/fetch-host-entries.sh apim-321-multi-dc-aks-am-gateway-deployment-2 deployment=apim-321-multi-dc-aks-am-gateway dc1 default
echo -e "$HOST_ENTRIES_ENV" | sudo tee -a /etc/hosts > /dev/null

#login into cluster2
echo "Login to the  DC1 to capture the hostname."
az aks get-credentials --resource-group $resourceGroup --name $aksCluster_2 --overwrite-existing --admin
sudo kubelogin convert-kubeconfig -l azurecli
#Add GW pod IPs as hosts.
#DC2
echo "The GW pod hostname capturing script will be executed against the DC2"
source $(pwd)/fetch-host-entries.sh apim-321-multi-dc-aks-am-gateway-deployment-1 deployment=apim-321-multi-dc-aks-am-gateway dc2 default
echo -e "$HOST_ENTRIES_ENV" | sudo tee -a /etc/hosts > /dev/null

source $(pwd)/fetch-host-entries.sh apim-321-multi-dc-aks-am-gateway-deployment-2 deployment=apim-321-multi-dc-aks-am-gateway dc2 default
echo -e "$HOST_ENTRIES_ENV" | sudo tee -a /etc/hosts > /dev/null
