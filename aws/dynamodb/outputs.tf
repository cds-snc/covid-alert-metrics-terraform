output "raw_metrics_name" {
  value = aws_dynamodb_table.raw_metrics.id
}

output "raw_metrics_arn" {
  value = aws_dynamodb_table.raw_metrics.arn
}

output "raw_metrics_stream_arn" {
  value = aws_dynamodb_table.raw_metrics.stream_arn
}

output "aggregate_metrics_name" {
  value = aws_dynamodb_table.aggregate_metrics.id
}

output "aggregate_metrics_arn" {
  value = aws_dynamodb_table.aggregate_metrics.arn
}
