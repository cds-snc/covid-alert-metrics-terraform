resource "random_string" "bucket_random_id" {
  length  = 5
  upper   = false
  number  = false
  special = false
}

locals {
  masked_metrics_bucket_name   = "masked-metrics-${random_string.bucket_random_id.result}-${var.env}"
  unmasked_metrics_bucket_name = "unmasked-metrics-${random_string.bucket_random_id.result}-${var.env}"
  error_sample_bucket_name     = "error-samples-${random_string.bucket_random_id.result}-${var.env}"
  log_bucket_name              = "logs-${random_string.bucket_random_id.result}-${var.env}"

}


module "masked_metrics" {
  source = "../modules/s3"
  name   = local.masked_metrics_bucket_name
}

module "unmasked_metrics" {
  source = "../modules/s3"
  name   = local.unmasked_metrics_bucket_name
}

module "metrics_error_log" {
  source      = "github.com/cds-snc/terraform-modules?ref=v0.0.28//S3"
  bucket_name = local.error_sample_bucket_name
  lifecycle_rule = [{
    id      = "expire"
    enabled = true
    expiration = {
      days = 3
    }
  }]
  billing_tag_value = var.billing_tag_value
  logging = {
    "target_bucket" = module.log_bucket.s3_bucket_id
    "target_prefix" = local.error_sample_bucket_name
  }
}

module "log_bucket" {
  source            = "github.com/cds-snc/terraform-modules?ref=v0.0.28//S3_log_bucket"
  bucket_name       = local.log_bucket_name
  billing_tag_value = var.billing_tag_value

}
