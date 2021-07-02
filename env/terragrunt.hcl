locals {
  vars = read_terragrunt_config("../env_vars.hcl")
}

inputs = {
  account_id                    = "${local.vars.inputs.account_id}"
  env                           = "${local.vars.inputs.env}"
  region                        = "ca-central-1"
  log_retention_in_days = "${local.vars.inputs.log_retention_in_days}"
}

remote_state {
  backend = "s3"
  generate = {
    path      = "backend.tf"
    if_exists = "overwrite_terragrunt"
  }
  config = {
    encrypt        = true
    bucket         = "cds-terraform-en-metrics-${local.vars.inputs.env}-tf"
    dynamodb_table = "terraform-state-lock-dynamo"
    region         = "ca-central-1"
    key            = "${path_relative_to_include()}/terraform.tfstate"
  }
}

generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite"
  contents  = file("./common/provider.tf")
}

generate "common_variables" {
  path      = "common_variables.tf"
  if_exists = "overwrite"
  contents  = file("./common/common_variables.tf")
}