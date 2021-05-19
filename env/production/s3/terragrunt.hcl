
include {
  path = find_in_parent_folders()
}

terraform {
  source = "git::https://github.com/cds-snc/covid-alert-metrics-terraform//aws/s3?ref=v${get_env("INFRASTRUCTURE_VERSION")}"
}


