#!/bin/bash

mkdir bin
wget -O bin/terragrunt "https://github.com/gruntwork-io/terragrunt/releases/download/$TERRAGRUNT_VERSION/terragrunt_linux_amd64"
wget -O bin/opa "https://github.com/open-policy-agent/opa/releases/download/$OPA_VERSION/opa_linux_amd64"
chmod +x bin/*