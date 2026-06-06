$ErrorActionPreference = "Stop"

Write-Host "Cleaning up the k8s-demo namespace..."

kubectl delete namespace k8s-demo --ignore-not-found=true

Write-Host ""
Write-Host "Cleanup requested. Wait a few seconds if Kubernetes is still terminating resources."
Write-Host "Run the next strategy script when the namespace is gone."
