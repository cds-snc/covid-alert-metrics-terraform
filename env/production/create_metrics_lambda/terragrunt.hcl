include {
  path = find_in_parent_folders()
}

dependencies {
  paths = ["../dynamodb", "../sqs", "../api_gateway"]
}

dependency "dynamodb" {
  config_path = "../dynamodb"

  mock_outputs_allowed_terraform_commands = ["validate", "plan"]
  mock_outputs = {
    raw_metrics_arn       = ""
    aggregate_metrics_arn = ""
  }
}

dependency "sqs" {
  config_path = "../sqs"

  mock_outputs_allowed_terraform_commands = ["validate", "plan"]
  mock_outputs = {
    dead_letter_queue_arn  = ""
    metrics_key_arn        = ""
    raw_metrics_arn        = ""
    aggregate_metrics_arn  = ""
    raw_metrics_stream_arn = ""
  }
}

dependency "api_gateway" {
  config_path = "../api_gateway"

  mock_outputs_allowed_terraform_commands = ["validate", "plan"]
  mock_outputs = {
    metrics_execution_arn = "arn:aws:execute-api:ca-central-1:123456789123:abcdef1ghi/*/POST/create_metrics"
    rest_api_id           = ""
    resource_id           = ""
    http_method           = "POST"
  }
}

inputs = {
  raw_metrics_arn        = dependency.dynamodb.outputs.raw_metrics_arn
  raw_metrics_stream_arn = dependency.dynamodb.outputs.raw_metrics_stream_arn

  dead_letter_queue_arn = dependency.sqs.outputs.dead_letter_queue_arn
  metrics_key_arn       = dependency.sqs.outputs.metrics_key_arn

  metrics_execution_arn = dependency.api_gateway.outputs.metrics_execution_arn
  rest_api_id           = dependency.api_gateway.outputs.rest_api_id
  resource_id           = dependency.api_gateway.outputs.resource_id
  http_method           = dependency.api_gateway.outputs.http_method

  metrics_error_log_s3_arn = dependency.s3.outputs.metrics_error_log_arn
  metrics_error_log_bucket = dependency.s3.outputs.metrics_error_log_id

  feature_count_alarms                = true
  create_metrics_max_avg_duration     = 10000
  create_metrics_dynamodb_wcu_max     = 65000
  large_payload_split_threshold_bytes = 204800
}

terraform {
  source = "git::https://github.com/cds-snc/covid-alert-metrics-terraform//aws/create_metrics_lambda?ref=v${get_env("INFRASTRUCTURE_VERSION")}"
}
