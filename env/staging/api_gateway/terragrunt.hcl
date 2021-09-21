include {
  path = find_in_parent_folders()
}

inputs = {
  api-description           = "Terraform Serverless api for COVID Alert metrics collection"
  apiKeyName                = "in-app-metrics-key"
  api_gateway_rate          = "10000"
  api_gateway_burst         = "5000"
  api_gateway_max_body_size = "20480"
  billing_tag_key           = "CostCentre"
  billing_tag_value         = "CovidShield"
  route53_zone_name         = "wild-samphire.cdssandbox.xyz"
}

terraform {
  source = "../../../aws//api_gateway"
}
