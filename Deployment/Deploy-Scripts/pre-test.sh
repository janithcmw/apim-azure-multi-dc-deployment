#This script is used to populate the DNS mappings relevant to the tests.
#dc-1
echo -e "10.8.0.111 analytics.dc1.am.wso2.com devportal.dc1.am.wso2.com gateway.dc1.am.wso2.com publisher.dc1.am.wso2.com traffic.manager.dc1.am.wso2.com key.manager.dc1.am.wso2.com" | sudo tee -a /etc/hosts > /dev/null

#dc-2
echo -e "10.9.0.111 analytics.dc2.am.wso2.com devportal.dc2.am.wso2.com gateway.dc2.am.wso2.com publisher.dc2.am.wso2.com traffic.manager.dc2.am.wso2.com key.manager.dc2.am.wso2.com" | sudo tee -a /etc/hosts > /dev/null

#TM-Hosts
echo "10.8.1.101 traffic.manager1.external.svc.dc1.am.wso2.com" | sudo tee -a /etc/hosts > /dev/null
echo "10.8.1.102 traffic.manager2.external.svc.dc1.am.wso2.com" | sudo tee -a /etc/hosts > /dev/null
echo "10.9.1.101 traffic.manager1.external.svc.dc2.am.wso2.com" | sudo tee -a /etc/hosts > /dev/null
echo "10.9.1.102 traffic.manager2.external.svc.dc2.am.wso2.com" | sudo tee -a /etc/hosts > /dev/null

#DB-Host
echo "10.8.1.103 mysql.service.am.wso2.com" | sudo tee -a /etc/hosts > /dev/null

#login into cluster1
az aks get-credentials --resource-group rg-multi-dc-cst-env-westeurope --name aks-multi-dc-cst-env-westeurope-001 --overwrite-existing --admin
sudo kubelogin convert-kubeconfig -l azurecli
#Add GW pod IPs as hosts.
#DC1
source $(pwd)/fetch-host-entries.sh apim-321-multi-dc-aks-am-gateway-deployment deployment=apim-321-multi-dc-aks-am-gateway dc1 default
echo -e "$HOST_ENTRIES_ENV" | sudo tee -a /etc/hosts > /dev/null

#login into cluster2
az aks get-credentials --resource-group rg-multi-dc-cst-env-westeurope --name aks-multi-dc-cst-env-westeurope-002 --overwrite-existing --admin
sudo kubelogin convert-kubeconfig -l azurecli
#Add GW pod IPs as hosts.
#DC2
source $(pwd)/fetch-host-entries.sh apim-321-multi-dc-aks-am-gateway-deployment deployment=apim-321-multi-dc-aks-am-gateway dc2 default
echo -e "$HOST_ENTRIES_ENV" | sudo tee -a /etc/hosts > /dev/null
