#!/bin/bash

# Usage: ./terraform_runner.sh apply dev.tfvars
#        ./terraform_runner.sh destroy dev.tfvars

ACTION=$1
TFVARS_FILE=$2

if [[ -z "$ACTION" || -z "$TFVARS_FILE" ]]; then
  echo "❌ Usage: $0 <apply|destroy> <tfvars-file>"
  exit 1
fi

if [[ "$ACTION" != "apply" && "$ACTION" != "destroy" ]]; then
  echo "❌ Invalid action: $ACTION. Use 'apply' or 'destroy'."
  exit 1
fi

if [[ ! -f "$TFVARS_FILE" ]]; then
  echo "❌ tfvars file not found: $TFVARS_FILE"
  exit 1
fi

echo "🚀 Running: terraform $ACTION -var-file=$TFVARS_FILE"
terraform init -upgrade
terraform $ACTION -var-file="$TFVARS_FILE" -auto-approve
