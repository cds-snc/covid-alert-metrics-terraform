data "aws_caller_identity" "current" {}
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
      days = var.error_sampling_lifecycle_days
    }
  }]
  billing_tag_value = var.billing_tag_value
  logging = {
    target_bucket = "cbs-satellite-account-bucket${data.aws_caller_identity.current.account_id}"
    target_prefix = "${data.aws_caller_identity.current.account_id}/s3_access_logs/${local.error_sample_bucket_name}/"
  }
}
