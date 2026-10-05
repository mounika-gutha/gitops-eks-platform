#!/usr/bin/env bash
set -euo pipefail

ALERTMANAGER_URL="${ALERTMANAGER_URL:-http://localhost:9093}"

curl --fail-with-body   -X POST   -H 'Content-Type: application/json'   "$ALERTMANAGER_URL/api/v2/alerts"   -d '[
    {
      "labels": {
        "alertname": "GitOpsSyntheticAlert",
        "severity": "warning",
        "service": "gitops-eks-platform"
      },
      "annotations": {
        "summary": "Synthetic GitOps alert",
        "description": "This alert verifies the Alertmanager routing path."
      }
    }
  ]'

echo
echo "Synthetic alert submitted."
