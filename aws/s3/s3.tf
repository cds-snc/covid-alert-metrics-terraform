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

data "aws_caller_identity" "current" {}

resource "aws_s3_bucket" "masked_metrics" {

  # Versioning on this resource is handled through git
  # tfsec:ignore:AWS077

  bucket = local.masked_metrics_bucket_name

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }

  logging {
    target_bucket = "cbs-satellite-account-bucket${data.aws_caller_identity.current.account_id}"
    target_prefix = "${data.aws_caller_identity.current.account_id}/s3_access_logs/${local.masked_metrics_bucket_name}/"
  }

}

resource "aws_s3_bucket" "unmasked_metrics" {

  # Versioning on this resource is handled through git
  # tfsec:ignore:AWS077

  bucket = local.unmasked_metrics_bucket_name
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }

  logging {
    target_bucket = "cbs-satellite-account-bucket${data.aws_caller_identity.current.account_id}"
    target_prefix = "${data.aws_caller_identity.current.account_id}/s3_access_logs/${local.unmasked_metrics_bucket_name}/"
  }

}