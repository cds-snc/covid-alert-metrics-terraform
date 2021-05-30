#!/bin/bash

eval=$(opa eval --format pretty --data .github/workflows/policy/resource-changes.rego --input "$GITHUB_WORKSPACE/tfplan.json" "data.terraform.analysis.$2")
echo "::set-output name=$1::$eval"