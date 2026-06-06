$ErrorActionPreference = "Stop"

Write-Host "Ensuring local Docker registry is running on localhost:5000..."

$registryName = "k8s-demo-registry"
$registry = docker ps -a --filter "name=^/$registryName$" --format "{{.Names}}"

if (-not $registry) {
  docker run -d -p 5000:5000 --restart=always --name $registryName registry:2 | Out-Null
} else {
  docker start $registryName | Out-Null
}

Write-Host "Building and pushing local images for Docker Desktop Kubernetes..."

docker build `
  --build-arg APP_VERSION=v1 `
  --build-arg APP_COLOR=blue `
  -t k8s-deploy-demo:v1 `
  -t localhost:5000/k8s-deploy-demo:v1 `
  .\app

docker build `
  --build-arg APP_VERSION=v2 `
  --build-arg APP_COLOR=green `
  -t k8s-deploy-demo:v2 `
  -t localhost:5000/k8s-deploy-demo:v2 `
  .\app

docker push localhost:5000/k8s-deploy-demo:v1
docker push localhost:5000/k8s-deploy-demo:v2
docker images k8s-deploy-demo
docker images localhost:5000/k8s-deploy-demo

Write-Host ""
Write-Host "Done. Next: .\scripts\powershell\02-recreate-v1.ps1"
