include {
  path = find_in_parent_folders()
}

dependencies {
  paths = ["../dynamodb", "../sqs"]
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

inputs = {
  raw_metrics_arn       = dependency.dynamodb.outputs.raw_metrics_arn
  aggregate_metrics_arn = dependency.dynamodb.outputs.aggregate_metrics_arn
  raw_metrics_stream_arn = dependency.dynamodb.outputs.raw_metrics_stream_arn

  dead_letter_queue_arn = dependency.sqs.outputs.dead_letter_queue_arn
  metrics_key_arn       = dependency.sqs.outputs.metrics_key_arn

  feature_count_alarms = true
  aggregate_metrics_max_avg_duration = 60000
  aggregate_metrics_dynamodb_wcu_max = 300
}

terraform {
  source = "../../../aws//aggregate_metrics_lambda"
}
