$ErrorActionPreference = "Stop"

Write-Host "Rolling Recreate demo from v1 to v2..."
Write-Host "Watch what happens: old pods terminate before new pods become available."

kubectl apply -f k8s\recreate\deployment-v2.yaml
kubectl rollout status deployment/k8s-deploy-demo -n k8s-demo
kubectl get pods -n k8s-demo -o wide

Write-Host ""
Write-Host "Refresh the browser. You should see green v2."
Write-Host "Next cleanup step: .\scripts\powershell\04-cleanup.ps1"
