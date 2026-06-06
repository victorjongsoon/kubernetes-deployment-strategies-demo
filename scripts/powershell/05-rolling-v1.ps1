$ErrorActionPreference = "Stop"

Write-Host "Starting RollingUpdate demo with v1..."

kubectl apply -f k8s\namespace.yaml
kubectl apply -f k8s\rolling-update\service.yaml
kubectl apply -f k8s\rolling-update\deployment-v1.yaml
kubectl rollout status deployment/k8s-deploy-demo -n k8s-demo
kubectl get pods -n k8s-demo -o wide

Write-Host ""
Write-Host "Access info: .\scripts\powershell\10-access-info.ps1"
Write-Host "Next rollout step: .\scripts\powershell\06-rolling-v2.ps1"
