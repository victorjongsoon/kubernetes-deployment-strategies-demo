#!/usr/bin/env bash
set -euo pipefail

echo "Rolling Recreate demo from v1 to v2..."
echo "Watch what happens: old pods terminate before new pods become available."

kubectl apply -f k8s/recreate/deployment-v2.yaml
kubectl rollout status deployment/k8s-deploy-demo -n k8s-demo
kubectl get pods -n k8s-demo -o wide

echo
echo "Refresh the browser. You should see green v2."
echo "Next cleanup step: bash scripts/bash/04-cleanup.sh"
