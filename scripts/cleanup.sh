#!/usr/bin/env bash
set -euo pipefail

kubectl delete namespace k8s-demo --ignore-not-found=true
