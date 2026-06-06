#!/usr/bin/env bash
set -euo pipefail

docker build \
  --build-arg APP_VERSION=v1 \
  --build-arg APP_COLOR=blue \
  -t k8s-deploy-demo:v1 \
  ./app

docker build \
  --build-arg APP_VERSION=v2 \
  --build-arg APP_COLOR=green \
  -t k8s-deploy-demo:v2 \
  ./app

docker images k8s-deploy-demo
