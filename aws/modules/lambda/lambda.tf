
locals {
  image_uri  = "${var.repository_url}:${var.tag}"
}

resource "aws_lambda_function" "lambda" {
  # checkov:skip=CKV_AWS_50:X-ray tracing only required during function debug
  # checkov:skip=CKV_AWS_115:Reserved concurrency not required (not latency sensitive)
  # checkov:skip=CKV_AWS_116:Dead Letter Queue not required (twice-a-day EventBridge invocation on predictable data)
  function_name = var.name

  package_type = "Image"
  image_uri    = local.image_uri

  timeout = 900

  memory_size = var.memory_size

  role = var.role_arn

  vpc_config {
    security_group_ids = [var.security_group_id]
    subnet_ids         = [var.subnet_id]
  }

  environment {
    variables = merge({
      TMP_PATH = local.mount_path
      },
    var.env_variables)
  }
}

resource "aws_cloudwatch_log_group" "metric_log" {
  # checkov:skip=CKV_AWS_158:Encryption using default CloudWatch service key is acceptable
  name              = "/aws/lambda/${var.name}"
  retention_in_days = var.log_retention_in_days
}
