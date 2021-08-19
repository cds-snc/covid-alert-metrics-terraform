inputs = {
  metrics_api_gateway_name = "save-metrics"
  sns_topic_warning_name   = "alert-warning"
  sns_topic_critical_name  = "alert-critical"

  feature_api_alarms                        = true
  feature_qr_code_alarms                    = false
  api_gateway_400_error_threshold           = 3000
  api_gateway_500_error_threshold           = 1000
  api_gateway_min_invocations               = 100
  api_gateway_max_invocations               = 65000
  api_gateway_max_latency                   = 60000
  api_gateway_traffic_change_percent        = 20
  app_500_qr_parse_error_critical_threshold = 3
  app_500_qr_parse_error_warning_threshold  = 1
}

include {
  path = find_in_parent_folders()
}

terraform {
  source = "git::https://github.com/cds-snc/covid-alert-metrics-terraform//aws/cloudwatch_alarms?ref=v${get_env("INFRASTRUCTURE_VERSION")}"
}
