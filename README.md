# Kubernetes Deployment Strategies Demo

A hands-on Flask app for visualizing Kubernetes deployment strategies: Recreate, RollingUpdate, Blue-Green, and Canary.

This repo supports the Medium article idea: **"I Built a Tiny App to Understand Kubernetes Deployment Strategies"**.

The story starts from a familiar developer pain point: deployment used to mean scheduled downtime emails, evening release windows, and anxious coordination with agencies or stakeholders. Kubernetes changes that mental model. A deployment becomes a controlled rollout that you can observe, pause, rollback, or switch with primitives that are built for change.

## What You Will See

The demo app shows:

- App version, such as `v1` or `v2`
- Deployment strategy name
- Pod name / hostname
- Request timestamp
- A visual color theme:
  - `v1` is blue
  - `v2` is green
  - Canary `v2` can appear orange

The app exposes:

- `GET /`
- `GET /healthz`
- `GET /api/info`

## Prerequisites

- Docker Desktop
- Kubernetes enabled in Docker Desktop
- `kubectl`
- PowerShell on Windows, or Bash on macOS/Linux/Git Bash/WSL

This repo uses a tiny local Docker registry at `localhost:5000` so Kubernetes can pull the demo images reliably.

## Project Structure

```text
kubernetes-deployment-strategies-demo/
|-- app/
|   |-- app.py
|   |-- requirements.txt
|   `-- Dockerfile
|-- k8s/
|   |-- namespace.yaml
|   |-- recreate/
|   |-- rolling-update/
|   |-- blue-green/
|   `-- canary/
|-- scripts/
|   |-- powershell/
|   `-- bash/
`-- README.md
```

## Build Images

PowerShell:

```powershell
.\scripts\powershell\01-build-images.ps1
```

Bash:

```bash
bash scripts/bash/01-build-images.sh
```

This starts a local registry if needed, then builds and pushes:

- `k8s-deploy-demo:v1`
- `k8s-deploy-demo:v2`
- `localhost:5000/k8s-deploy-demo:v1`
- `localhost:5000/k8s-deploy-demo:v2`

You can also run the app locally without Kubernetes:

```bash
docker run --rm -p 5000:5000 k8s-deploy-demo:v1
```

Then open [http://localhost:5000](http://localhost:5000).

## Browser Access

The Kubernetes Services use `type: LoadBalancer`.

After applying a strategy, check the Service:

```powershell
kubectl get service k8s-deploy-demo -n k8s-demo
```

If your local Kubernetes provider exposes the LoadBalancer, open the `EXTERNAL-IP` shown by that command. On some Docker Desktop setups, this may be `localhost`. On others, the assigned IP may not be reachable from Windows.

If the LoadBalancer address is not reachable locally, use `kubectl proxy`:

```powershell
kubectl proxy --port=8001
```

Keep that terminal open, then browse to:

```text
http://localhost:8001/api/v1/namespaces/k8s-demo/services/k8s-deploy-demo:80/proxy/
```

That proxy URL is a local viewing helper. The Kubernetes exposure model in the manifests is still `LoadBalancer`.

## Guided Script Demo

Run these from the repository root. On Windows PowerShell, use `.\scripts\powershell\<script-name>.ps1`. The `.sh` versions are in `scripts/bash/`.

Build local images:

```powershell
.\scripts\powershell\01-build-images.ps1
```

Recreate:

```powershell
.\scripts\powershell\02-recreate-v1.ps1
.\scripts\powershell\03-recreate-v2.ps1
.\scripts\powershell\04-cleanup.ps1
```

RollingUpdate:

```powershell
.\scripts\powershell\05-rolling-v1.ps1
.\scripts\powershell\06-rolling-v2.ps1
.\scripts\powershell\04-cleanup.ps1
```

Blue-Green:

```powershell
.\scripts\powershell\07-blue-green-blue.ps1
.\scripts\powershell\08-blue-green-green.ps1
.\scripts\powershell\04-cleanup.ps1
```

Canary:

```powershell
.\scripts\powershell\09-canary.ps1
.\scripts\powershell\91-api-loop.ps1 "http://localhost:8001/api/v1/namespaces/k8s-demo/services/k8s-deploy-demo:80/proxy"
.\scripts\powershell\04-cleanup.ps1
```

Useful helper:

```powershell
.\scripts\powershell\80-watch-pods.ps1
```

## Strategy 1: Recreate

Recreate terminates the old pods before creating the new pods. This is the closest Kubernetes version of the old "downtime window" feeling.

Start with `v1`:

```powershell
kubectl apply -f k8s\namespace.yaml
kubectl apply -f k8s\recreate\service.yaml
kubectl apply -f k8s\recreate\deployment-v1.yaml
kubectl rollout status deployment/k8s-deploy-demo -n k8s-demo
```

Deploy `v2`:

```powershell
kubectl apply -f k8s\recreate\deployment-v2.yaml
kubectl rollout status deployment/k8s-deploy-demo -n k8s-demo
```

What to watch: old blue `v1` pods terminate first, then green `v2` pods start. During the gap, requests may fail.

## Strategy 2: RollingUpdate

RollingUpdate gradually replaces old pods with new pods. With `maxUnavailable: 1` and `maxSurge: 1`, Kubernetes can run old and new versions side by side during the rollout.

Start with `v1`:

```powershell
kubectl apply -f k8s\namespace.yaml
kubectl apply -f k8s\rolling-update\service.yaml
kubectl apply -f k8s\rolling-update\deployment-v1.yaml
kubectl rollout status deployment/k8s-deploy-demo -n k8s-demo
```

Deploy `v2`:

```powershell
kubectl apply -f k8s\rolling-update\deployment-v2.yaml
kubectl rollout status deployment/k8s-deploy-demo -n k8s-demo
```

Rollback if needed:

```powershell
kubectl rollout undo deployment/k8s-deploy-demo -n k8s-demo
```

What to watch: blue `v1` and green `v2` pods coexist while Kubernetes moves traffic through the Service.

## Strategy 3: Blue-Green

Blue-Green keeps two complete environments available. Blue runs `v1`; green runs `v2`. Traffic switches by changing the Service selector.

Start blue:

```powershell
kubectl apply -f k8s\namespace.yaml
kubectl apply -f k8s\blue-green\blue-deployment.yaml
kubectl apply -f k8s\blue-green\service-blue.yaml
kubectl rollout status deployment/k8s-deploy-demo-blue -n k8s-demo
```

Create green while traffic still points to blue:

```powershell
kubectl apply -f k8s\blue-green\green-deployment.yaml
kubectl rollout status deployment/k8s-deploy-demo-green -n k8s-demo
```

Switch traffic to green:

```powershell
kubectl apply -f k8s\blue-green\service-green.yaml
```

Switch traffic back to blue:

```powershell
kubectl apply -f k8s\blue-green\service-blue.yaml
```

What to watch: both versions are running, but the Service selector decides which color receives traffic.

## Strategy 4: Canary

Canary sends a small portion of traffic to the new version before fully rolling it out. This demo uses a simple Kubernetes-native approximation: 9 stable `v1` pods and 1 canary `v2` pod behind one Service.

```powershell
kubectl apply -f k8s\namespace.yaml
kubectl apply -f k8s\canary\service.yaml
kubectl apply -f k8s\canary\stable-deployment.yaml
kubectl apply -f k8s\canary\canary-deployment.yaml
kubectl rollout status deployment/k8s-deploy-demo-stable -n k8s-demo
kubectl rollout status deployment/k8s-deploy-demo-canary -n k8s-demo
```

Refresh the browser several times or call the API in a loop:

```powershell
.\scripts\powershell\91-api-loop.ps1 "http://localhost:8001/api/v1/namespaces/k8s-demo/services/k8s-deploy-demo:80/proxy"
```

What to watch: most responses come from blue stable `v1` pods, while some come from the canary `v2` pod.

This is a simple Kubernetes-native approximation, not precise traffic weighting. Production-grade canary releases often use Ingress controllers, a service mesh, Argo Rollouts, or Flagger.

## What Kubernetes Natively Supports

Kubernetes Deployment natively supports `Recreate` and `RollingUpdate`. Blue-Green and Canary are common release patterns built using Kubernetes primitives such as Deployments, labels, selectors, Services, and replica counts.

## Comparison

| Strategy | Downtime Risk | Rollback Ease | Complexity | Kubernetes-Native Support |
| --- | --- | --- | --- | --- |
| Recreate | High | Simple, but downtime is expected | Low | Native Deployment strategy |
| RollingUpdate | Low | Easy with `kubectl rollout undo` | Low to medium | Native Deployment strategy |
| Blue-Green | Low during switch, but requires capacity for both versions | Very easy by switching the Service back | Medium | Built from primitives |
| Canary | Low when done carefully | Easy if canary is isolated | Medium to high | Built from primitives; precise weighting needs extra tooling |

## Medium Article Screenshot And GIF Ideas

- Recreate: show the browser failing or briefly unavailable while pods restart.
- RollingUpdate: record `kubectl get pods -n k8s-demo -L version -w` as old and new pods coexist.
- Blue-Green: show the app changing from blue `v1` to green `v2` after applying `service-green.yaml`.
- Canary: refresh the browser or loop `/api/info` and capture occasional canary responses.
- Summary shot: put the browser beside `kubectl get pods -n k8s-demo --show-labels`.

## Useful Debugging Commands

```powershell
kubectl get all -n k8s-demo
kubectl get pods -n k8s-demo --show-labels
kubectl get pods -n k8s-demo -L version,track,color
kubectl describe service k8s-deploy-demo -n k8s-demo
kubectl logs -l app=k8s-deploy-demo -n k8s-demo --tail=50
```
