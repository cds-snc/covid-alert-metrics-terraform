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
  period              = "600"
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

resource "aws_cloudwatch_metric_alarm" "metrics_api_gateway_traffic_change" {
  alarm_name          = "metrics-api-gateway-traffic-change"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "1"
  threshold           = var.api_gateway_traffic_change_percent
  alarm_description   = "Maximum traffic percentage change between current and previous day"
  alarm_actions       = [data.aws_sns_topic.alert_warning.arn]

  metric_query {
    id    = "current"
    label = "Current count"

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

  metric_query {
    id         = "delta"
    expression = "RATE(current) * PERIOD(current)"
    label      = "Delta"
  }

  metric_query {
    id         = "previous"
    expression = "current - delta"
    label      = "Previous count"
  }

  metric_query {
    id          = "percent_change"
    expression  = "ABS(100 * delta/previous)"
    label       = "Percent change"
    return_data = "true"
  }
}
