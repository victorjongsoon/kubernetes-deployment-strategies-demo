#!/usr/bin/env bash
set -euo pipefail

echo "Cleaning up the k8s-demo namespace..."

kubectl delete namespace k8s-demo --ignore-not-found=true

echo
echo "Cleanup requested. Wait a few seconds if Kubernetes is still terminating resources."
echo "Run the next strategy script when the namespace is gone."
