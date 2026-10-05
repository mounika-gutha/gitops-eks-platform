# Runbook

## CrashLoopBackOff

### Symptom
A pod repeatedly restarts.

### Likely cause
Application crash, bad configuration, failed dependency, or insufficient resources.

### Check
```bash
kubectl get pods -A
kubectl describe pod <POD> -n <NAMESPACE>
kubectl logs <POD> -n <NAMESPACE> --previous
```

### Fix
Correct the application/configuration and let Argo CD reconcile.

### Escalation
Application owner first; platform team if scheduling or node-related.

## NodeNotReady

### Symptom
A worker node is not Ready.

### Check
```bash
kubectl get nodes
kubectl describe node <NODE>
```

### Fix
Check EC2/node group health, kubelet, networking and resource pressure.

### Escalation
Platform/cloud team.

## High CPU

### Check
```bash
kubectl top nodes
kubectl top pods -A
```

### Fix
Scale the workload, tune requests/limits, or investigate a CPU-heavy release.

## High Memory

### Check
```bash
kubectl top nodes
kubectl top pods -A
```

### Fix
Check memory leaks, requests/limits and HPA behavior.

## High 5xx Rate

### Check
```bash
kubectl get pods -n sample-api-dev
kubectl logs -n sample-api-dev deploy/<DEPLOYMENT>
```

Inspect the application RED dashboard.

### Fix
Roll back the image tag through Git.

## ArgoCD Out of Sync

### Check
```bash
kubectl -n argocd get applications
kubectl -n argocd describe application <APPLICATION>
```

### Fix
Determine whether the difference is expected. Revert unintended manual cluster changes.

## ArgoCD Degraded

### Check
```bash
kubectl -n argocd get applications
kubectl get events -A --sort-by=.lastTimestamp
```

### Fix
Inspect the degraded resource and correct the Git desired state.

## Disk Pressure

### Check
```bash
kubectl describe node <NODE>
```

### Fix
Remove unnecessary workload/storage, increase node capacity, or adjust retention.

## Certificate Expiry

### Check
Inspect the certificate endpoint and certificate-management system.

### Fix
Renew the certificate before expiry and confirm the ALB/Ingress serves the new certificate.
