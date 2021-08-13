# Catch "QR parse errors" from the covid alert app
resource "aws_cloudwatch_metric_alarm" "metrics_app_errors_500_qr_parse_above_critical_threshold" {
  alarm_name          = "metrics-app-errors-500-qr-parse-above-critical-threshold"
  comparison_operator = "GreaterThanThreshold"
  period              = "3600"
  evaluation_periods  = "24"
  datapoints_to_alarm = "1"
  treat_missing_data  = "notBreaching"
  metric_name         = "Errors"
  namespace           = "CovidAlertApp"
  statistic           = "Sum"
  threshold           = var.app_500_qr_parse_error_critical_threshold
  alarm_description   = "This metric monitors error-500-qr-parse errors in the covid alert app and generates a warning alarm"

  alarm_actions = [data.aws_sns_topic.alert_warning.arn]
  dimensions = {
    Identifier = "error-500-qr-parse"
  }
}

resource "aws_cloudwatch_metric_alarm" "metrics_app_errors_500_qr_parse_above_warning_threshold" {
  alarm_name          = "metrics-app-errors-500-qr-parse-above-warning-threshold"
  comparison_operator = "GreaterThanThreshold"
  period              = "3600"
  evaluation_periods  = "24"
  datapoints_to_alarm = "1"
  treat_missing_data  = "notBreaching"
  metric_name         = "Errors"
  namespace           = "CovidAlertApp"
  statistic           = "Sum"
  threshold           = var.app_500_qr_parse_error_warning_threshold
  alarm_description   = "This metric monitors error-500-qr-parse errors in the covid alert app and generates a warning alarm"

  alarm_actions = [data.aws_sns_topic.alert_warning.arn]
  dimensions = {
    Identifier = "error-500-qr-parse"
  }
}
