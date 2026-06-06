#!/usr/bin/env bash
set -euo pipefail

echo "RollingUpdate demo: gradually moving from v1 to v2..."

kubectl apply -f k8s/rolling-update/deployment-v2.yaml
kubectl rollout status deployment/k8s-deploy-demo -n k8s-demo
kubectl get pods -n k8s-demo -o wide

echo
echo "Refresh the browser. You should see green v2 after rollout completes."
echo "Next cleanup step: bash scripts/bash/04-cleanup.sh"
