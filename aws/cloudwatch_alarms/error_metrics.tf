# Catch "QR parse errors" from the covid alert app
resource "aws_cloudwatch_metric_alarm" "metrics_app_errors_500_qr_parse_above_critical_threshold" {
  alarm_name          = "metrics-app-errors-500-qr-parse-above-critical-threshold"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "1"
  metric_name         = "Errors"
  namespace           = "CovidAlertApp"
  period              = "86400"
  statistic           = "Sum"
  threshold           = var.app_500_qr_parse_error_critical_threshold
  alarm_description   = "This metric monitors error-500-qr-parse errors in the covid alert app"

  alarm_actions = [data.aws_sns_topic.alert_critical.arn]
  dimensions = {
    Identifier = "error-500-qr-parse"
  }
}

resource "aws_cloudwatch_metric_alarm" "metrics_app_errors_500_qr_parse_above_warning_threshold" {
  alarm_name          = "metrics-app-errors-500-qr-parse-above-warning-threshold"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "1"
  metric_name         = "Errors"
  namespace           = "CovidAlertApp"
  period              = "86400"
  statistic           = "Sum"
  threshold           = var.app_500_qr_parse_error_warning_threshold
  alarm_description   = "This metric monitors error-500-qr-parse errors in the covid alert app"

  alarm_actions = [data.aws_sns_topic.alert_warning.arn]
  dimensions = {
    Identifier = "error-500-qr-parse"
  }
}
