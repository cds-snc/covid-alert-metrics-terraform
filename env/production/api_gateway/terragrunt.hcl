include {
  path = find_in_parent_folders()
}

inputs = {
  api-description           = "Terraform Serverless api for COVID Alert metrics collection"
  apiKeyName                = "in-app-metrics-key"
  api_gateway_rate          = "10000"
  api_gateway_burst         = "5000"
  api_gateway_max_body_size = "120000"
  billing_tag_key           = "CostCentre"
  billing_tag_value         = "CovidShield"
  route53_zone_name         = "covid-notification.alpha.canada.ca"
}

terraform {
  source = "git::https://github.com/cds-snc/covid-alert-metrics-terraform//aws/api_gateway?ref=v${get_env("INFRASTRUCTURE_VERSION")}"
}
