#
# Lambda: capture ECS events
#
resource "aws_lambda_function" "ecs_events" {
  # checkov:skip=CKV_AWS_50: X-ray tracing not required for this function
  # checkov:skip=CKV_AWS_115: No function-level concurrent execution limit required
  # checkov:skip=CKV_AWS_116: No Dead Letter Queue required
  # checkov:skip=CKV_AWS_117: VPC not required for this Lambda

  function_name = "ecs_events"
  description   = "Lambda function to write ECS events to a CloudWatch log group."

  filename    = data.archive_file.ecs_events.output_path
  handler     = "ecs_events.lambda_handler"
  runtime     = "python3.9"
  timeout     = 30
  memory_size = 128

  role             = aws_iam_role.ecs_events_lambda.arn
  source_code_hash = filebase64sha256(data.archive_file.ecs_events.output_path)

  depends_on = [
    aws_iam_role_policy_attachment.ecs_events_lambda_basic_execution
  ]

  tags = {
    (var.billing_tag_key) = var.billing_tag_value
  }
}

data "archive_file" "ecs_events" {
  type        = "zip"
  source_file = "ecs_events/ecs_events.py"
  output_path = "/tmp/ecs_events.py.zip"
}

resource "aws_lambda_permission" "ecs_events" {
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.ecs_events.arn
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.ecs_events.arn
}

#
# IAM: Lambda role
#
resource "aws_iam_role" "ecs_events_lambda" {
  name               = "EcsEventsLambda"
  assume_role_policy = data.aws_iam_policy_document.lambda_assume_policy.json
}

resource "aws_iam_role_policy_attachment" "ecs_events_lambda_basic_execution" {
  role       = aws_iam_role.ecs_events_lambda.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

data "aws_iam_policy_document" "lambda_assume_policy" {
  statement {
    effect = "Allow"
    actions = [
      "sts:AssumeRole",
    ]
    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

#
# Event rule: defines events to capture and Lambda to trigger
#
resource "aws_cloudwatch_event_rule" "ecs_events" {
  name        = "metrics-${var.env}-ecs-events"
  description = "Capture ECS events from the metrics cluster"
  event_pattern = jsonencode({
    "detail" : {
      "clusterArn" : [aws_ecs_cluster.in_app_metrics.arn]
    }
  })
}

resource "aws_cloudwatch_event_target" "ecs_events" {
  rule = aws_cloudwatch_event_rule.ecs_events.name
  arn  = aws_lambda_function.ecs_events.arn
}

#
# Log group: captures the ECS event logs from the Lambda function
#
resource "aws_cloudwatch_log_group" "ecs_events" {
  # checkov:skip=CKV_AWS_158: Encryption with default service key is acceptable
  name              = "/aws/lambda/${aws_lambda_function.ecs_events.function_name}"
  retention_in_days = 14
}

#
# Alarm: trigger if a warning or error is detected in the ECS event logs
#
resource "aws_cloudwatch_log_metric_filter" "ecs_warn_error_event" {
  name           = "MetricEcsWarnErrorEvent"
  pattern        = "?Warn ?Error"
  log_group_name = aws_cloudwatch_log_group.ecs_events.name

  metric_transformation {
    name          = "EcsWarnErrorEvent"
    namespace     = "CovidShieldMetrics"
    value         = "1"
    default_value = "0"
  }
}

resource "aws_cloudwatch_metric_alarm" "ecs_warn_error_event" {
  alarm_name          = "MetricEcsWarnErrorEvent"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "1"
  metric_name         = aws_cloudwatch_log_metric_filter.ecs_warn_error_event.name
  namespace           = "CovidShieldMetrics"
  period              = "60"
  statistic           = "Sum"
  threshold           = "0"
  treat_missing_data  = "notBreaching"

  alarm_description = "Metrics ECS warning or error event detected"
  alarm_actions     = [data.aws_sns_topic.alert_warning.arn]
}
