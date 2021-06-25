data "archive_file" "lambda_aggregate_metric" {
  type        = "zip"
  source_file = "lambda/aggregate_values.js"
  output_path = "/tmp/lambda_aggregate_values.js.zip"
}


resource "aws_lambda_function" "aggregate_metrics" {
  function_name = "aggregate_metrics"
  # filename      = "/tmp/lambda_aggregate_values.js.zip"

  source_code_hash = data.archive_file.lambda_aggregate_metric.output_base64sha256

  handler = "aggregate_values.handler"
  runtime = "nodejs12.x"
  role    = aws_iam_role.aggregator.arn
  timeout = 60

  environment {
    variables = {
      DEAD_LETTER_QUEUE_URL = data.aws_sqs_queue.aggregation_lambda_dead_letter.id
    }
  }

  vpc_config {
    security_group_ids = [aws_security_group.aggregate_metrics_sg.id]
    subnet_ids         = data.aws_subnet_ids.private.ids
  }

}

resource "aws_lambda_event_source_mapping" "raw_metric_stream" {
  event_source_arn  = data.aws_dynamodb_table.raw_metrics.stream_arn
  function_name     = aws_lambda_function.aggregate_metrics.arn
  starting_position = "LATEST"
  batch_size        = 100
}

resource "aws_cloudwatch_log_group" "metrics" {
  name              = "/aws/lambda/${aws_lambda_function.aggregate_metrics.function_name}"
  retention_in_days = 14
}