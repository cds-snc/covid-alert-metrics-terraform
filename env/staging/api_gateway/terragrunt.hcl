include {
  path = find_in_parent_folders()
}

inputs = {
  api-description = "Terraform Serverless api for COVID Alert metrics collection"
  apiKeyName = "in-app-metrics-key"
  api_gateway_rate = "10000"
  api_gateway_burst = "5000"
  billing_tag_key   = "CostCentre"
  billing_tag_value = "CovidShield"
  service_name = "save-metrics"
}

terraform {
  source = "../../../aws//api_gateway"
}
