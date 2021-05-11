
locals {
  image_uri = "${var.repository_url}:${var.tag}"
}

resource "aws_lambda_function" "lambda" {
  function_name = var.name

  package_type = "Image"
  image_uri    = local.image_uri

  timeout = 900

  role = var.role_arn

  vpc_config {
    security_group_ids = [var.security_group_id]
    subnet_ids         = [var.subnet_id]
  }

  environment {
    variables = var.env_variables
  }
}

resource "aws_cloudwatch_log_group" "metric_log" {
  name              = "/aws/lambda/${var.name}"
  retention_in_days = 14
}
