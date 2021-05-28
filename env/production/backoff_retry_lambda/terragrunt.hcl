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
    dead_letter_queue_arn = ""
    dead_letter_queue_url = ""
    metrics_key_arn       = ""
  }
}

inputs = {
  raw_metrics_arn       = dependency.dynamodb.outputs.raw_metrics_arn
  aggregate_metrics_arn = dependency.dynamodb.outputs.aggregate_metrics_arn

  dead_letter_queue_arn = dependency.sqs.outputs.dead_letter_queue_arn
  dead_letter_queue_url = dependency.sqs.outputs.dead_letter_queue_url
  metrics_key_arn       = dependency.sqs.outputs.metrics_key_arn

  backoff_retry_max_avg_duration = 10000
}

terraform {
  source = "git::https://github.com/cds-snc/covid-alert-metrics-terraform//aws/backoff_retry_lambda?ref=v${get_env("INFRASTRUCTURE_VERSION")}"
}
