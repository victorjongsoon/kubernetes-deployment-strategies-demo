#!/usr/bin/env bash
set -euo pipefail

echo "Starting Recreate demo with v1..."

kubectl apply -f k8s/namespace.yaml
kubectl apply -f k8s/recreate/service.yaml
kubectl apply -f k8s/recreate/deployment-v1.yaml
kubectl rollout status deployment/k8s-deploy-demo -n k8s-demo
kubectl get pods -n k8s-demo -o wide

echo
echo "Access info: bash scripts/bash/10-access-info.sh"
echo "Next rollout step: bash scripts/bash/03-recreate-v2.sh"
