#!/bin/bash

echo "$1=$(jq -r ."$1" .github/workflows/manifest/versions.json)"
