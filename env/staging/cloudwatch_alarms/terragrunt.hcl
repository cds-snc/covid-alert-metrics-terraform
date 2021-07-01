inputs = {
  metrics_api_gateway_name = "save-metrics"
  sns_topic_warning_name   = "alert-warning"
  sns_topic_critical_name  = "alert-critical"

  feature_api_alarms              = true
  api_gateway_400_error_threshold = 95
  api_gateway_500_error_threshold = 200
  api_gateway_min_invocations     = 0
  api_gateway_max_invocations     = 10000
  api_gateway_max_latency         = 3000
}

include {
  path = find_in_parent_folders()
}

terraform {
  source = "../../../aws//cloudwatch_alarms"
}
