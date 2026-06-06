$ErrorActionPreference = "Stop"

Write-Host "Starting Canary demo: 9 stable v1 pods and 1 canary v2 pod."

kubectl apply -f k8s\namespace.yaml
kubectl apply -f k8s\canary\service.yaml
kubectl apply -f k8s\canary\stable-deployment.yaml
kubectl apply -f k8s\canary\canary-deployment.yaml
kubectl rollout status deployment/k8s-deploy-demo-stable -n k8s-demo
kubectl rollout status deployment/k8s-deploy-demo-canary -n k8s-demo
kubectl get pods -n k8s-demo --show-labels

Write-Host ""
Write-Host "Access info: .\scripts\powershell\10-access-info.ps1"
Write-Host "Then refresh the browser several times."
Write-Host "You should mostly see v1, with occasional canary v2 responses."
Write-Host "Finish with: .\scripts\powershell\04-cleanup.ps1"
