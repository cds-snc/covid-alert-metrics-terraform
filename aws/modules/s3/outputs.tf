output id { 
  value = aws_s3_bucket.masked_metrics.id
  description = "The id (name) of the bucket"
}

output arn { 
  value = aws_s3_bucket.masked_metrics.arn
  description = "The arn of the bucket"
}