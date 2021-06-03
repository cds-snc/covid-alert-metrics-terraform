#!/bin/bash
set -euo pipefail

TERRAGRUNT_DIR=$1
MISSING_TAGGED_MODULE=$(find "$TERRAGRUNT_DIR" -maxdepth 2 -name "terragrunt.hcl" -exec grep -L "git::https://github.com/cds-snc/covid-alert-metrics-terraform//aws/" {} \;)

if [[ -n "$MISSING_TAGGED_MODULE" ]]; then
    echo "ERROR - found Teragrunt configuration in \"$TERRAGRUNT_DIR\" without a tagged module:"
    echo "$MISSING_TAGGED_MODULE"
    exit 1
else
    echo "SUCCESS - No untagged modules found in \"$TERRAGRUNT_DIR\" "
    exit 0
fi