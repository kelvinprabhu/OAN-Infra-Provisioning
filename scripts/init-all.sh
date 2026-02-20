#!/usr/bin/env bash
# Init all Terraform environments for a given cloud provider
# Usage: ./scripts/init-all.sh aws

set -euo pipefail

CLOUD=${1:?Usage: $0 <aws|gcp|azure|self-hosted>}
ENVS=(dev box uat staging prod)

for env in "${ENVS[@]}"; do
  echo "==> Initializing $CLOUD/$env"
  pushd "$CLOUD/$env" > /dev/null
  terraform init -backend=false
  terraform validate
  popd > /dev/null
done

echo "✅ All $CLOUD environments initialized"
