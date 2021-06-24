resource "aws_cloudwatch_metric_alarm" "aggregate_metrics_dynamodb_wcu" {
  count               = var.feature_count_alarms ? 1 : 0
  alarm_name          = "aggregate-metrics-dynamodb-wcu"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "1"
  metric_name         = "ConsumedWriteCapacityUnits"
  namespace           = "AWS/DynamoDB"
  period              = "60"
  statistic           = "Sum"
  threshold           = var.aggregate_metrics_dynamodb_wcu_max
  alarm_description   = "This metric monitors maximum write capacity units for the aggregate_metrics table"

  alarm_actions = [data.aws_sns_topic.alert_critical.arn]
  dimensions = {
    TableName = data.aws_dynamodb_table.aggregate_metrics.name
  }
}

###
# AWS Lambda
###

resource "aws_cloudwatch_metric_alarm" "aggregate_metrics_average_duration" {
  alarm_name          = "aggregate-metrics-average-duration"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "1"
  metric_name         = "Duration"
  namespace           = "AWS/Lambda"
  period              = "60"
  statistic           = "Average"
  threshold           = var.aggregate_metrics_max_avg_duration
  alarm_description   = "This metric monitors average duration for the aggregate_metrics lambda"

  alarm_actions = [data.aws_sns_topic.alert_critical.arn]
  dimensions = {
    FunctionName = aws_lambda_function.aggregate_metrics.function_name
  }
}