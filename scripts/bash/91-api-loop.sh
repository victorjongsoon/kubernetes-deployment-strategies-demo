#!/usr/bin/env bash
set -euo pipefail

base_url="${1:-http://localhost:8001/api/v1/namespaces/k8s-demo/services/k8s-deploy-demo:80/proxy}"
base_url="${base_url%/}"
info_url="${base_url}/api/info"

echo "Calling ${info_url} repeatedly..."

for i in {1..20}; do
  curl -s "${info_url}"
  echo
  sleep 1
done
