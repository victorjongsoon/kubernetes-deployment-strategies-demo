$ErrorActionPreference = "Stop"

function Get-PodAge {
  param([datetime]$CreatedAt)

  $age = (Get-Date).ToUniversalTime() - $CreatedAt.ToUniversalTime()

  if ($age.TotalSeconds -lt 60) {
    return "{0}s" -f [math]::Floor($age.TotalSeconds)
  }

  if ($age.TotalMinutes -lt 60) {
    return "{0}m" -f [math]::Floor($age.TotalMinutes)
  }

  return "{0}h" -f [math]::Floor($age.TotalHours)
}

$seen = @{}

Write-Host "Watching pods. Press Ctrl+C to stop."
Write-Host ""
"{0,-8} {1,-48} {2,-5} {3,-18} {4,8} {5,6} {6,-7}" -f "TIME", "NAME", "READY", "STATUS", "RESTARTS", "AGE", "VERSION"
"{0,-8} {1,-48} {2,-5} {3,-18} {4,8} {5,6} {6,-7}" -f ("-" * 8), ("-" * 48), ("-" * 5), ("-" * 18), ("-" * 8), ("-" * 6), ("-" * 7)

while ($true) {
  $pods = kubectl get pods -n k8s-demo -o json | ConvertFrom-Json

  foreach ($pod in $pods.items | Sort-Object { $_.metadata.creationTimestamp }, { $_.metadata.name }) {
    $statuses = @($pod.status.containerStatuses)
    $readyCount = @($statuses | Where-Object { $_.ready }).Count
    $totalCount = $statuses.Count
    $restarts = ($statuses | Measure-Object -Property restartCount -Sum).Sum
    if ($null -eq $restarts) { $restarts = 0 }

    $status = if ($pod.metadata.deletionTimestamp) { "Terminating" } else { $pod.status.phase }
    $age = Get-PodAge ([datetime]$pod.metadata.creationTimestamp)
    $version = if ($pod.metadata.labels.version) { $pod.metadata.labels.version } else { "-" }
    $ready = "$readyCount/$totalCount"
    $state = "$ready|$status|$restarts|$version"
    $name = $pod.metadata.name

    if (-not $seen.ContainsKey($name) -or $seen[$name] -ne $state) {
      $seen[$name] = $state
      "{0,-8} {1,-48} {2,-5} {3,-18} {4,8} {5,6} {6,-7}" -f (Get-Date -Format "HH:mm:ss"), $name, $ready, $status, $restarts, $age, $version
    }
  }

  Start-Sleep -Seconds 1
}
