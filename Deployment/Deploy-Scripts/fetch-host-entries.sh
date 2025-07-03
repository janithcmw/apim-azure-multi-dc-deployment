#!/bin/bash

# Usage: ./add-hosts.sh <deployment-name> <labels of pods> <DC> [namespace]

DEPLOYMENT_NAME="$1"
LABELS="$2"
DC="$3"
NAMESPACE="${4:-default}"
MAX_ATTEMPTS=30
SLEEP_SECONDS=10

# --- Flags ---
DEPLOYMENT_SUCCESS=false
PODS_FOUND=false
HOSTS_READY=false

# --- Input Validation ---
if [ -z "$DEPLOYMENT_NAME" ] || [ -z "$LABELS" ] || [ -z "$DC" ]; then
  echo "Usage: $0 <deployment-name> <labels of pods> <DC> [namespace]"
  DEPLOYMENT_SUCCESS=false
  return 0 2>/dev/null || exit 0
fi

echo "Waiting for deployment '$DEPLOYMENT_NAME' in namespace '$NAMESPACE' to complete rollout..."

attempt=1
while [ $attempt -le $MAX_ATTEMPTS ]; do
  STATUS_OUTPUT=$(kubectl rollout status deployment/"$DEPLOYMENT_NAME" -n "$NAMESPACE" --watch=false 2>&1)

  if echo "$STATUS_OUTPUT" | grep -q "successfully rolled out"; then
    echo "Deployment successfully rolled out."
    DEPLOYMENT_SUCCESS=true
    break
  elif echo "$STATUS_OUTPUT" | grep -q "failed"; then
    echo "Deployment rollout failed: $STATUS_OUTPUT"
    DEPLOYMENT_SUCCESS=false
    break
  else
    echo "Attempt $attempt/$MAX_ATTEMPTS: Deployment not ready yet..."
    sleep $SLEEP_SECONDS
    ((attempt++))
  fi
done

if [ "$DEPLOYMENT_SUCCESS" != true ]; then
  echo "Deployment did not succeed after $MAX_ATTEMPTS attempts."
  return 0 2>/dev/null || exit 0
fi

# --- Fetch pod IPs ---
echo "Fetching pod IPs for deployment '$DEPLOYMENT_NAME'..."
POD_IPS=$(kubectl get pods -n "$NAMESPACE" -l "$LABELS" \
  -o jsonpath='{range .items[*]}{.status.podIP}{"\n"}{end}' | grep -v '^$')

if [ -n "$POD_IPS" ]; then
  PODS_FOUND=true
else
  echo "No pod IPs found."
  return 0 2>/dev/null || exit 0
fi

# --- Generate host entries ---
ipcount=0
HOST_ENTRIES=""
for ip in $POD_IPS; do
  HOST_ENTRY="$ip ${DEPLOYMENT_NAME}-$ipcount-$DC.am.wso2.com"
  echo "Host entry [$ipcount]: $HOST_ENTRY"
  HOST_ENTRIES+="$HOST_ENTRY\n"
  ((ipcount++))
done

if [ -n "$HOST_ENTRIES" ]; then
  HOSTS_READY=true
  export HOST_ENTRIES_ENV="$(echo -e "$HOST_ENTRIES" | sed '${/^$/d}')"
  echo ""
  echo "Host entries generated. You can run this command to update /etc/hosts:"
  echo "echo -e \"\$HOST_ENTRIES_ENV\" | sudo tee -a /etc/hosts > /dev/null"
else
  echo "Host entry list is empty."
fi

# --- Final flag report (for debugging or parent scripts) ---
export DEPLOYMENT_SUCCESS
export PODS_FOUND
export HOSTS_READY
