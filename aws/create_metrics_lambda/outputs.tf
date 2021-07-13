output "lambda_invoke_arn" {
  value = aws_lambda_function.create_metrics.invoke_arn
}
