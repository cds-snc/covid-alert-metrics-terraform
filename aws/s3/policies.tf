

data "aws_iam_policy_document" "write_s3_metrics_csv_buckets" {
  statement {

    effect = "Allow"
    actions = [
      "s3:PutObject",
      "s3:PutObjectAcl",
    ]
    resources = [
      aws_s3_bucket.unmasked_metrics.arn,
      aws_s3_bucket.masked_metrics.arn
    ]

  }

}

resource "aws_iam_policy" "write_s3_metrics_csv_buckets" {
  name   = "WriteS3CSVBuckets"
  path   = "/"
  policy = data.aws_iam_policy_document.write_s3_metrics_csv_buckets.json
}