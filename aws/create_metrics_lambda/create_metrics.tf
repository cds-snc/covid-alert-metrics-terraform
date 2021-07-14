data "archive_file" "lambda_create_metric" {
  type        = "zip"
  source_file = "lambda/create_metric.js"
  output_path = "/tmp/lambda_create_metric.js.zip"
}


resource "aws_lambda_function" "create_metrics" {
  function_name = "create_metrics"
  filename      = "/tmp/lambda_create_metric.js.zip"

  source_code_hash = data.archive_file.lambda_create_metric.output_base64sha256

  handler = "create_metric.handler"
  runtime = "nodejs12.x"
  role    = aws_iam_role.createmetrics.arn
  timeout = 60

  environment {
    variables = {
      TABLE_NAME = data.aws_dynamodb_table.raw_metrics.name
    }
  }

  vpc_config {
    security_group_ids = [aws_security_group.create_metrics_sg.id]
    subnet_ids         = data.aws_subnet_ids.private.ids
  }

}

resource "aws_lambda_event_source_mapping" "raw_metric_stream" {
  event_source_arn  = data.aws_dynamodb_table.raw_metrics.stream_arn
  function_name     = aws_lambda_function.create_metrics.arn
  starting_position = "LATEST"
  batch_size        = 100
}

resource "aws_cloudwatch_log_group" "metrics" {
  # checkov:skip=CKV_AWS_158:Encryption using default CloudWatch service key is acceptable
  name              = "/aws/lambda/${aws_lambda_function.create_metrics.function_name}"
  retention_in_days = var.log_retention_in_days
}

resource "aws_lambda_permission" "apigw" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.create_metrics.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${var.metrics_execution_arn}/*/POST/${var.service_name}"
}

resource "aws_api_gateway_integration" "metrics" {
  rest_api_id             = var.rest_api_id
  resource_id             = var.resource_id
  http_method             = var.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.create_metrics.invoke_arn
}