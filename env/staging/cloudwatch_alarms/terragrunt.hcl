include {
  path = find_in_parent_folders()
}

dependencies {
  paths = ["../api_gateway"]
}

inputs = {
  sns_topic_warning_name  = "alert-warning"
  sns_topic_critical_name = "alert-critical"

  feature_api_alarms                        = true
  api_gateway_400_error_threshold           = 95
  api_gateway_500_error_threshold           = 200
  api_gateway_min_invocations               = 0
  api_gateway_max_invocations               = 10000
  api_gateway_max_latency                   = 3000
  api_gateway_traffic_change_percent        = 20
  app_500_qr_parse_error_critical_threshold = 3
  app_500_qr_parse_error_warning_threshold  = 1
}

terraform {
  source = "../../../aws//cloudwatch_alarms"
  extra_arguments "extra_args" {
    commands = "${get_terraform_commands_that_need_vars()}"
    optional_var_files = [
      "${find_in_parent_folders("variables.auto.tfvars", "ignore")}",
    ]
  }
}
