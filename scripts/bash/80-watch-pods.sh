#!/usr/bin/env bash
set -euo pipefail

echo "Watching pods with VERSION label..."
echo

watch -n 2 'kubectl get pods -n k8s-demo -L version'
