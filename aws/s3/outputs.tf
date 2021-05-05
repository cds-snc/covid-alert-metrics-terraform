output write_s3_csv_buckets { 
  value = aws_iam_policy.write_s3_metrics_csv_buckets.arn
}

output masked_metrics_bucket { 
  value = aws_s3_bucket.masked_metrics.id
}

output unmasked_metrics_bucket { 
  value = aws_s3_bucket.unmasked_metrics.id
}