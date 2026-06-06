#!/usr/bin/env bash
set -euo pipefail

echo "Ensuring local Docker registry is running on localhost:5000..."

registry_name="k8s-demo-registry"

if ! docker ps -a --filter "name=^/${registry_name}$" --format "{{.Names}}" | grep -qx "${registry_name}"; then
  docker run -d -p 5000:5000 --restart=always --name "${registry_name}" registry:2 >/dev/null
else
  docker start "${registry_name}" >/dev/null
fi

echo "Building and pushing local images for Docker Desktop Kubernetes..."

docker build \
  --build-arg APP_VERSION=v1 \
  --build-arg APP_COLOR=blue \
  -t k8s-deploy-demo:v1 \
  -t localhost:5000/k8s-deploy-demo:v1 \
  ./app

docker build \
  --build-arg APP_VERSION=v2 \
  --build-arg APP_COLOR=green \
  -t k8s-deploy-demo:v2 \
  -t localhost:5000/k8s-deploy-demo:v2 \
  ./app

docker push localhost:5000/k8s-deploy-demo:v1
docker push localhost:5000/k8s-deploy-demo:v2
docker images k8s-deploy-demo
docker images localhost:5000/k8s-deploy-demo

echo
echo "Done. Next: bash scripts/bash/02-recreate-v1.sh"
