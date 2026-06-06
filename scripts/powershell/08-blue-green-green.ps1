$ErrorActionPreference = "Stop"

Write-Host "Creating green v2 and switching Service traffic from blue to green..."

kubectl apply -f k8s\blue-green\green-deployment.yaml
kubectl rollout status deployment/k8s-deploy-demo-green -n k8s-demo
kubectl apply -f k8s\blue-green\service-green.yaml
kubectl get pods -n k8s-demo --show-labels

Write-Host ""
Write-Host "Refresh the browser. You should see green v2."
Write-Host "Rollback traffic to blue anytime with: kubectl apply -f k8s\blue-green\service-blue.yaml"
Write-Host "Next cleanup step: .\scripts\powershell\04-cleanup.ps1"
