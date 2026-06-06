#!/usr/bin/env bash
set -euo pipefail

echo "Creating green v2 and switching Service traffic from blue to green..."

kubectl apply -f k8s/blue-green/green-deployment.yaml
kubectl rollout status deployment/k8s-deploy-demo-green -n k8s-demo
kubectl apply -f k8s/blue-green/service-green.yaml
kubectl get pods -n k8s-demo --show-labels

echo
echo "Refresh the browser. You should see green v2."
echo "Rollback traffic to blue anytime with: kubectl apply -f k8s/blue-green/service-blue.yaml"
echo "Next cleanup step: bash scripts/bash/04-cleanup.sh"
