$ErrorActionPreference = "Stop"

Write-Host "Starting Blue-Green demo. Traffic points to blue v1."

kubectl apply -f k8s\namespace.yaml
kubectl apply -f k8s\blue-green\blue-deployment.yaml
kubectl apply -f k8s\blue-green\service-blue.yaml
kubectl rollout status deployment/k8s-deploy-demo-blue -n k8s-demo
kubectl get pods -n k8s-demo --show-labels

Write-Host ""
Write-Host "Access info: .\scripts\powershell\10-access-info.ps1"
Write-Host "Next create green and switch traffic: .\scripts\powershell\08-blue-green-green.ps1"
