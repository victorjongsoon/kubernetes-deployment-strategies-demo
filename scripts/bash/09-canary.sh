#!/usr/bin/env bash
set -euo pipefail

echo "Starting Canary demo: 9 stable v1 pods and 1 canary v2 pod."

kubectl apply -f k8s/namespace.yaml
kubectl apply -f k8s/canary/service.yaml
kubectl apply -f k8s/canary/stable-deployment.yaml
kubectl apply -f k8s/canary/canary-deployment.yaml
kubectl rollout status deployment/k8s-deploy-demo-stable -n k8s-demo
kubectl rollout status deployment/k8s-deploy-demo-canary -n k8s-demo
kubectl get pods -n k8s-demo --show-labels

echo
echo "Access info: bash scripts/bash/10-access-info.sh"
echo "Then refresh the browser several times."
echo "You should mostly see v1, with occasional canary v2 responses."
echo "Finish with: bash scripts/bash/04-cleanup.sh"
