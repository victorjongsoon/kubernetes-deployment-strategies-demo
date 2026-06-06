$ErrorActionPreference = "Stop"

Write-Host "RollingUpdate demo: gradually moving from v1 to v2..."

kubectl apply -f k8s\rolling-update\deployment-v2.yaml
kubectl rollout status deployment/k8s-deploy-demo -n k8s-demo
kubectl get pods -n k8s-demo -o wide

Write-Host ""
Write-Host "Refresh the browser. You should see green v2 after rollout completes."
Write-Host "Next cleanup step: .\scripts\powershell\04-cleanup.ps1"
