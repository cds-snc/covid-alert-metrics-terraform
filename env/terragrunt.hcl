locals {
  vars = read_terragrunt_config("../env_vars.hcl")
}

inputs = {
  account_id = "${local.vars.inputs.account_id}"
  env        = "${local.vars.inputs.env}"
  region     = "ca-central-1"
}

terraform {
  before_hook "copy_terraform_tf" {
    commands = ["init-from-module"]
    execute  = ["cp", "${get_parent_terragrunt_dir()}/provider.tf", "${get_terragrunt_dir()}"]
  }

  before_hook "copy_common_variables_tf" {
    commands = ["init-from-module"]
    execute  = ["cp", "${get_parent_terragrunt_dir()}/common_variables.tf", "${get_terragrunt_dir()}"]
  }

  after_hook "rm_terraform_tf" {
    commands     = concat(get_terraform_commands_that_need_vars(), ["validate"])
    execute      = ["rm", "${get_terragrunt_dir()}/provider.tf"]
    run_on_error = true
  }

  after_hook "rm_common_variables_tf" {
    commands     = concat(get_terraform_commands_that_need_vars(), ["validate"])
    execute      = ["rm", "${get_terragrunt_dir()}/common_variables.tf"]
    run_on_error = true
  }
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