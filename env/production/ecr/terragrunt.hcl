include {
  path = find_in_parent_folders()
}

terraform {
  source = "git::https://https://github.com/cds-snc/covid-alert-metrics-terraform/aws/ecr?ref=v${get_env("INFRASTRUCTURE_VERSION")}"
}
