data "aws_caller_identity" "current" {}

resource "aws_s3_bucket" "masked_metrics" {
  # checkov:skip=CKV_AWS_21:Versioning on this resource is handled through git
  # checkov:skip=CKV_AWS_52:MFA delete only works with versioning
  # checkov:skip=CKV_AWS_144:Cross-region replication not required (source of record for data is GitHub)
  # checkov:skip=CKV_AWS_145:Using default service key for encryption is acceptable
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
