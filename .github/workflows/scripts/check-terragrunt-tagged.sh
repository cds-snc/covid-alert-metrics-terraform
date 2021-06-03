#!/bin/bash
set -euo pipefail

TERRAGRUNT_DIR=$1
MISSING_TAGGED_MODULE=$(grep -LR "git::https://github.com/cds-snc/covid-alert-metrics-terraform//aws/" "$TERRAGRUNT_DIR"/*/terragrunt.hcl)

if [[ -n "$MISSING_TAGGED_MODULE" ]]; then
    echo "ERROR - found Teragrunt configuration in \"$TERRAGRUNT_DIR\" without a tagged module:"
    echo "$MISSING_TAGGED_MODULE"
    exit 1
else
    echo "SUCCESS - No untagged modules found in \"$TERRAGRUNT_DIR\" "
    exit 0
fi