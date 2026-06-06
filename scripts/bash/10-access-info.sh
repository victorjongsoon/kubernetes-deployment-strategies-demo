#!/usr/bin/env bash
set -euo pipefail

echo "Service access details:"
kubectl get service k8s-deploy-demo -n k8s-demo

echo
echo "If EXTERNAL-IP is reachable, open it in the browser."
echo "If it is not reachable locally, run this in another terminal:"
echo "  kubectl proxy --port=8001"
echo
echo "Then open:"
echo "  http://localhost:8001/api/v1/namespaces/k8s-demo/services/k8s-deploy-demo:80/proxy/"
