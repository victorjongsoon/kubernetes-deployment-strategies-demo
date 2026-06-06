$ErrorActionPreference = "Stop"

$BaseUrl = if ($args.Count -gt 0) {
  $args[0].TrimEnd("/")
} else {
  "http://localhost:8001/api/v1/namespaces/k8s-demo/services/k8s-deploy-demo:80/proxy"
}

$InfoUrl = "$BaseUrl/api/info"

Write-Host "Calling $InfoUrl repeatedly..."

for ($i = 1; $i -le 20; $i++) {
  curl.exe -s $InfoUrl
  Write-Host ""
  Start-Sleep -Seconds 1
}
