#!/usr/bin/env bash
set -euo pipefail

TAG="${1:-}"
FILE="gitops/environments/dev/values-dev.yaml"

if [[ -z "$TAG" ]]; then
  echo "Usage: $0 <image-tag>"
  exit 1
fi

if [[ ! -f "$FILE" ]]; then
  echo "File not found: $FILE"
  exit 1
fi

sed -i.bak -E "s#^  tag: .*#  tag: \"${TAG}\"#" "$FILE"
rm -f "${FILE}.bak"

echo "Updated $FILE to image tag $TAG"
