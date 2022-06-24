include {
  path = find_in_parent_folders()
}

dependencies {
  paths = ["../dynamodb", "../sqs"]
}

terraform {
  source = "git::https://github.com/cds-snc/covid-alert-metrics-terraform//aws/empty?ref=v${get_env("INFRASTRUCTURE_VERSION")}"
}
