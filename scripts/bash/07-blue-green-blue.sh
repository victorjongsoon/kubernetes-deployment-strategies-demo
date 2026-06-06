#!/usr/bin/env bash
set -euo pipefail

echo "Starting Blue-Green demo. Traffic points to blue v1."

kubectl apply -f k8s/namespace.yaml
kubectl apply -f k8s/blue-green/blue-deployment.yaml
kubectl apply -f k8s/blue-green/service-blue.yaml
kubectl rollout status deployment/k8s-deploy-demo-blue -n k8s-demo
kubectl get pods -n k8s-demo --show-labels

echo
echo "Access info: bash scripts/bash/10-access-info.sh"
echo "Next create green and switch traffic: bash scripts/bash/08-blue-green-green.sh"
