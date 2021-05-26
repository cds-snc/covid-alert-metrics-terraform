include {
  path = find_in_parent_folders()
}

terraform {
  source = "git::https://github.com/cds-snc/covid-alert-metrics-terraform//aws/dynamodb?ref=v${get_env("INFRASTRUCTURE_VERSION")}"
}
