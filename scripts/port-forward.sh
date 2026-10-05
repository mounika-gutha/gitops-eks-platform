#!/usr/bin/env bash
set -euo pipefail

TARGET="${1:-grafana}"

case "$TARGET" in
  grafana)
    kubectl -n monitoring port-forward svc/kube-prometheus-stack-grafana 3000:80
    ;;
  argocd)
    kubectl -n argocd port-forward svc/argocd-server 8080:443
    ;;
  prometheus)
    kubectl -n monitoring port-forward svc/kube-prometheus-stack-prometheus 9090:9090
    ;;
  alertmanager)
    kubectl -n monitoring port-forward svc/kube-prometheus-stack-alertmanager 9093:9093
    ;;
  *)
    echo "Usage: $0 {grafana|argocd|prometheus|alertmanager}"
    exit 1
    ;;
esac
