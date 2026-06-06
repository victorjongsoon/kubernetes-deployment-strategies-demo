#!/usr/bin/env bash
set -euo pipefail

kubectl get pods -n k8s-demo -w
