data "aws_caller_identity" "current" {}

resource "aws_s3_bucket" "masked_metrics" {
  # checkov:skip=CKV_AWS_21:Versioning on this resource is handled through git
  bucket = var.name

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }

  logging {
    target_bucket = "cbs-satellite-account-bucket${data.aws_caller_identity.current.account_id}"
    target_prefix = "${data.aws_caller_identity.current.account_id}/s3_access_logs/${var.name}/"
  }

}