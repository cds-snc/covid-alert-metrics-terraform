include {
  path = find_in_parent_folders()
}

inputs = {
  api-description   = "Terraform Serverless api for COVID Alert metrics collection"
  apiKeyName        = "in-app-metrics-key"
  api_gateway_rate  = "10000"
  api_gateway_burst = "5000"
  billing_tag_key   = "CostCentre"
  billing_tag_value = "CovidShield"
}

terraform {
  source = "git::https://github.com/cds-snc/covid-alert-metrics-terraform//aws/api_gateway?ref=v${get_env("INFRASTRUCTURE_VERSION")}"
  extra_arguments "extra_args" {
    commands = "${get_terraform_commands_that_need_vars()}"
    optional_var_files = [
      "${find_in_parent_folders("variables.auto.tfvars", "ignore")}",
    ]
  }
}
