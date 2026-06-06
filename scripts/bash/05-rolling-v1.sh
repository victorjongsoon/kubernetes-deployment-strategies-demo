#!/usr/bin/env bash
set -euo pipefail

echo "Starting RollingUpdate demo with v1..."

kubectl apply -f k8s/namespace.yaml
kubectl apply -f k8s/rolling-update/service.yaml
kubectl apply -f k8s/rolling-update/deployment-v1.yaml
kubectl rollout status deployment/k8s-deploy-demo -n k8s-demo
kubectl get pods -n k8s-demo -o wide

echo
echo "Access info: bash scripts/bash/10-access-info.sh"
echo "Next rollout step: bash scripts/bash/06-rolling-v2.sh"
