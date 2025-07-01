# Validate only the services and the ingresses since they are the k8s objects that interact with the LBs, Vnets and Snets

NAMESPACE=${1:-default}

echo "Waiting for all resources in namespace: $NAMESPACE to be deleted..."

echo "Waiting for services to terminate..."
while [[ $(kubectl get svc -n "$NAMESPACE" --no-headers | grep -iv 'kubernetes' | wc -l) -ne 0 ]]; do
  sleep 5
done
echo "All services are successfully terminated."


echo "Waiting for Ingresses to terminate..."
while [[ $(kubectl get ingress -n "$NAMESPACE" --no-headers | wc -l) -ne 0 ]]; do
  sleep 5
done
echo "All ingresses are successfully terminated."