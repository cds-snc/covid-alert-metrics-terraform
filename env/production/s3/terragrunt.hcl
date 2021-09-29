
include {
  path = find_in_parent_folders()
}

inputs = {
  error_sampling_lifecycle_days = 1
}

terraform {
  source = "git::https://github.com/cds-snc/covid-alert-metrics-terraform//aws/s3?ref=v${get_env("INFRASTRUCTURE_VERSION")}"
}


