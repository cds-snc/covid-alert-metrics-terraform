#!/bin/bash

terragrunt plan --terragrunt-non-interactive --terragrunt-log-level warn -no-color -out="$GITHUB_WORKSPACE/tfplan.binary" |& tee tempfile
terragrunt show -json "$GITHUB_WORKSPACE/tfplan.binary" > "$GITHUB_WORKSPACE/tfplan.json"
plan_output=$(cat tempfile)
plan_output="${plan_output//'%'/'%25'}"
plan_output="${plan_output//$'\n'/'%0A'}"
plan_output="${plan_output//$'\r'/'%0D'}"
echo "::set-output name=stdout::$plan_output"