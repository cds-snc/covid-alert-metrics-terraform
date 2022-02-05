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
    target_bucket = var.cbs_satellite_bucket_name
    target_prefix = "/s3_access_logs/${var.name}/"
  }

}

resource "aws_s3_bucket_public_access_block" "masked_metrics" {
  bucket = aws_s3_bucket.masked_metrics.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
