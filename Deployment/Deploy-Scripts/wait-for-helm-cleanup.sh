#!/bin/bash

NAMESPACE=${1:-default}

echo "Waiting for all resources in namespace: $NAMESPACE to be deleted..."

while true; do
  REMAINING=$(kubectl api-resources --namespaced=true -o name | \
    xargs -n1 kubectl get --no-headers -n "$NAMESPACE" --ignore-not-found 2>/dev/null | \
    grep -v '^kubernetes ' | wc -l)

  if [ "$REMAINING" -eq 0 ]; then
    echo "All resources deleted in namespace: $NAMESPACE"
    break
  else
    echo "$REMAINING resource(s) still present in $NAMESPACE. Waiting..."
    sleep 3
  fi
done