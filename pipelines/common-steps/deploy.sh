#!/bin/bash
set -euo pipefail
set -x

ENVIRONMENT="${ENVIRONMENT:-staging}"
AWS_REGION="${AWS_REGION:-us-east-1}"

# Si no viene STACK_NAME, lo construimos
if [[ -z "${STACK_NAME:-}" ]]; then
  if [[ "$ENVIRONMENT" == "staging" ]]; then
    STACK_NAME="cp14-mogo-staging"
  else
    STACK_NAME="cp14-mogo-production"
  fi
fi

TEMPLATE=".aws-sam/build/template.yaml"
if [[ ! -f "$TEMPLATE" ]]; then
  TEMPLATE="template.yaml"
fi

sam deploy \
  --template-file "$TEMPLATE" \
  --stack-name "$STACK_NAME" \
  --region "$AWS_REGION" \
  --resolve-s3 \
  --capabilities CAPABILITY_IAM \
  --no-confirm-changeset \
  --force-upload \
  --no-fail-on-empty-changeset \
  --no-progressbar \
  --parameter-overrides Stage="$ENVIRONMENT" \
  --config-file samconfig.toml \
  --config-env "$ENVIRONMENT"
