#!/usr/bin/env bash
# Run terraform plan for a specific cloud/environment
# Usage: ./scripts/plan-env.sh aws dev

set -euo pipefail

CLOUD=${1:?Usage: $0 <cloud> <env>}
ENV=${2:?Usage: $0 <cloud> <env>}

cd "$CLOUD/$ENV"

if [[ ! -f "terraform.tfvars" ]]; then
  echo "❌ Missing terraform.tfvars in $CLOUD/$ENV"
  echo "   Copy terraform.tfvars.example -> terraform.tfvars and fill in values"
  exit 1
fi

echo "==> Planning $CLOUD/$ENV"
terraform init -reconfigure
terraform plan -var-file=terraform.tfvars -out=tfplan
echo "✅ Plan saved to $CLOUD/$ENV/tfplan"
