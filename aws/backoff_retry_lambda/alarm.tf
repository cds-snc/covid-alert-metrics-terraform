resource "aws_cloudwatch_metric_alarm" "backoff_retry_average_duration" {
  alarm_name          = "backoff-retry--average-duration"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "1"
  metric_name         = "Duration"
  namespace           = "AWS/Lambda"
  period              = "60"
  extended_statistic  = "p99"
  threshold           = var.backoff_retry_max_avg_duration
  alarm_description   = "This metric monitors average duration for the backoff_retry lambda"

  alarm_actions = [data.aws_sns_topic.alert_critical.arn]

  dimensions = {
    FunctionName = aws_lambda_function.backoff_retry.function_name
  }
}