output "metrics_key_arn" {
  value = aws_kms_key.metrics_key.arn
}

output "dead_letter_queue_arn" {
  value = aws_sqs_queue.aggregation_lambda_dead_letter.arn
}

output "dead_letter_queue_url" {
  value = aws_sqs_queue.aggregation_lambda_dead_letter.id
}