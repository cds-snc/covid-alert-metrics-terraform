output "raw_metrics_arn" {
  value = aws_dynamodb_table.raw_metrics.arn
}

output "raw_metrics_stream_arn" {
  value = aws_dynamodb_table.raw_metrics.stream_arn
}

output "aggregate_metrics_arn" {
  value = aws_dynamodb_table.aggregate_metrics.arn
}