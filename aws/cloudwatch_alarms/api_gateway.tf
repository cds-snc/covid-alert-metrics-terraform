# Catch "400 bad requests" when the API gateway receives an invalid metrics payload
resource "aws_cloudwatch_metric_alarm" "metrics_api_gateway_400_errors_above_threshold" {
  alarm_name          = "metrics-api-gateway-400-errors-above-threshold"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "1"
  metric_name         = "4XXError"
  namespace           = "AWS/ApiGateway"
  period              = "60"
  statistic           = "Sum"
  threshold           = var.api_gateway_400_error_threshold
  alarm_description   = "This metric monitors 400 errors in the metrics API gateway"

  alarm_actions = [data.aws_sns_topic.alert_critical.arn]
  dimensions = {
    ApiName = data.aws_api_gateway_rest_api.metrics.name
  }
}

resource "aws_cloudwatch_metric_alarm" "metrics_api_gateway_500_errors_above_threshold" {
  alarm_name          = "metrics-api-gateway-500-errors-above-threshold"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "1"
  metric_name         = "5XXError"
  namespace           = "AWS/ApiGateway"
  period              = "60"
  statistic           = "Sum"
  threshold           = var.api_gateway_500_error_threshold
  alarm_description   = "This metric monitors 500 errors in the metrics API gateway"

  alarm_actions = [data.aws_sns_topic.alert_critical.arn]
  dimensions = {
    ApiName = data.aws_api_gateway_rest_api.metrics.name
  }
}

resource "aws_cloudwatch_metric_alarm" "metrics_api_gateway_min_invocations_threshold" {
  alarm_name          = "metrics-api-gateway-below-minimum-invocations"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = "1"
  metric_name         = "Count"
  namespace           = "AWS/ApiGateway"
  period              = "60"
  statistic           = "Sum"
  threshold           = var.api_gateway_min_invocations
  alarm_description   = "This metric monitors minimum API gateway invocations for the metrics API gateway"

  alarm_actions = [data.aws_sns_topic.alert_critical.arn]
  dimensions = {
    ApiName = data.aws_api_gateway_rest_api.metrics.name
  }
}

resource "aws_cloudwatch_metric_alarm" "metrics_api_gateway_max_invocations_threshold" {
  count               = var.feature_api_alarms ? 1 : 0
  alarm_name          = "metrics-api-gateway-above-maximum-invocations"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "1"
  metric_name         = "Count"
  namespace           = "AWS/ApiGateway"
  period              = "60"
  statistic           = "Sum"
  threshold           = var.api_gateway_max_invocations
  alarm_description   = "This metric monitors maximum API gateway invocations for the metrics API gateway"

  alarm_actions = [data.aws_sns_topic.alert_critical.arn]
  dimensions = {
    ApiName = data.aws_api_gateway_rest_api.metrics.name
  }
}

resource "aws_cloudwatch_metric_alarm" "metrics_api_gateway_max_latency_threshold" {
  alarm_name          = "metrics-api-gateway-above-maximum-latency"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "1"
  metric_name         = "Latency"
  namespace           = "AWS/ApiGateway"
  period              = "60"
  extended_statistic  = "p95"
  threshold           = var.api_gateway_max_latency
  alarm_description   = "This metric monitors maximum API gateway latency for the metrics API gateway"

  alarm_actions = [data.aws_sns_topic.alert_critical.arn]
  dimensions = {
    ApiName = data.aws_api_gateway_rest_api.metrics.name
  }
}

# Alarm for a 24 hour period that checks if API traffic has changed significantly (2 standard deviations)
resource "aws_cloudwatch_metric_alarm" "metrics_api_gateway_traffic_anomaly" {
  count               = var.feature_api_alarms ? 1 : 0
  alarm_name          = "metrics-api-gateway-traffic-anomaly"
  comparison_operator = "LessThanLowerOrGreaterThanUpperThreshold"
  evaluation_periods  = "1"
  threshold_metric_id = "daily_count_expected"
  alarm_description   = "This metric monitors for significant changes in API gateway traffic"
  alarm_actions       = [data.aws_sns_topic.alert_critical.arn]

  metric_query {
    id          = "daily_count_expected"
    expression  = "ANOMALY_DETECTION_BAND(daily_count)"
    label       = "Daily API requests (Expected)"
    return_data = "true"
  }

  metric_query {
    id          = "daily_count"
    return_data = "true"
    metric {
      metric_name = "Count"
      namespace   = "AWS/ApiGateway"
      period      = "86400"
      stat        = "Sum"
      unit        = "Count"

      dimensions = {
        ApiName = data.aws_api_gateway_rest_api.metrics.name
      }
    }
  }
}
