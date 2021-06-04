data "archive_file" "lambda_backoff_retry" {
  type        = "zip"
  source_file = "lambda/backoff_retry.js"
  output_path = "/tmp/lambda_backoff_retry.js.zip"
}

resource "aws_lambda_function" "backoff_retry" {
  # checkov:skip=CKV_AWS_50:X-ray tracing only required during function debug
  # checkov:skip=CKV_AWS_115:Reserved concurrency not required by backoff_retry (not latency sensitive)
  # checkov:skip=CKV_AWS_116:Dead Letter Queue is handled by backoff_retry function code

  function_name = "backoff_retry"
  filename      = "/tmp/lambda_backoff_retry.js.zip"

  source_code_hash = data.archive_file.lambda_backoff_retry.output_base64sha256

  handler = "backoff_retry.handler"
  runtime = "nodejs12.x"
  role    = aws_iam_role.backoff.arn

  vpc_config {
    security_group_ids = [aws_security_group.backoff_retry_sg.id]
    subnet_ids         = data.aws_subnet_ids.private.ids
  }

  environment {
    variables = {
      DEAD_LETTER_QUEUE_URL = var.dead_letter_queue_url
    }
  }
}

resource "aws_lambda_event_source_mapping" "dead_letters" {
  event_source_arn = var.dead_letter_queue_arn
  function_name    = aws_lambda_function.backoff_retry.arn
}

resource "aws_cloudwatch_log_group" "backoff_log_group" {
  name              = "/aws/lambda/${aws_lambda_function.backoff_retry.function_name}"
  retention_in_days = 14
}
