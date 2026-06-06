$ErrorActionPreference = "Stop"

Write-Host "Service access details:"
kubectl get service k8s-deploy-demo -n k8s-demo

Write-Host ""
Write-Host "If EXTERNAL-IP is reachable, open it in the browser."
Write-Host "If it is not reachable locally, run this in another terminal:"
Write-Host "  kubectl proxy --port=8001"
Write-Host ""
Write-Host "Then open:"
Write-Host "  http://localhost:8001/api/v1/namespaces/k8s-demo/services/k8s-deploy-demo:80/proxy/"
