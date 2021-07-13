output "metrics_execution_arn" {
  value = aws_api_gateway_rest_api.metrics.execution_arn
}

output "rest_api_id" {
  value = aws_api_gateway_rest_api.metrics.id
}

output "resource_id" {
  value = aws_api_gateway_method.create_method.resource_id
}

output "http_method" {
  value = aws_api_gateway_method.create_method.http_method
}
