resource "random_string" "bucket_random_id" {
  length  = 5
  upper   = false
  number  = false
  special = false
}

locals {
  masked_metrics_bucket_name = "masked-metrics-${random_string.bucket_random_id.result}-${var.env}"
  unmasked_metrics_bucket_name = "unmasked-metrics-${random_string.bucket_random_id.result}-${var.env}"
}


module "masked_metrics" { 
  source = "../modules/s3"
  name = local.masked_metrics_bucket_name
}

module "unmasked_metrics" { 
  source = "../modules/s3"
  name = local.unmasked_metrics_bucket_name
}