dependencies {
  paths = ["../network", "../s3", "../ecr", "../dynamodb"]
}

include {
  path = find_in_parent_folders()
}

dependency "dynamodb" {
  config_path = "../dynamodb"
}

dependency "network" {
  config_path = "../network"

  mock_outputs_allowed_terraform_commands = ["validate", "plan"]
  mock_outputs = {
    private_subnet_id = ""
    csv_etl_sg_id     = ""
  }
}

dependency "ecr" {
  config_path = "../ecr"

  mock_outputs_allowed_terraform_commands = ["validate", "plan"]
  mock_outputs = {
    inapp_metrics_etl_repository_url = ""
    inapp_metrics_etl_repository_arn = ""
  }
}

dependency "s3" {
  config_path = "../s3"

  mock_outputs_allowed_terraform_commands = ["validate", "plan"]
  mock_outputs = {

    masked_metrics_id    = "masked_metrics"
    masked_metrics_arn   = ""
    unmasked_metrics_id  = "unmasked_metrics"
    unmasked_metrics_arn = ""

  }
}

inputs = {

  # Server Metrics Inputs
  server_metrics_etl_repository_url   = dependency.ecr.outputs.server_metrics_etl_repository_url
  server_metrics_etl_repository_arn   = dependency.ecr.outputs.server_metrics_etl_repository_arn
  server_tag                          = "b83a460d229464f29afc24babe75eabe8c8813a9"
  masked_server_schedule_expression   = "cron(0 5 * * ? *)"
  unmasked_server_schedule_expression = "cron(0 5 * * ? *)"
  server_events_endpoint              = "https://retrieval.covid-notification.alpha.canada.ca/events"

  # Appstore Metrics Inputs
  appstore_metrics_etl_repository_url   = dependency.ecr.outputs.appstore_metrics_etl_repository_url
  appstore_metrics_etl_repository_arn   = dependency.ecr.outputs.appstore_metrics_etl_repository_arn
  appstore_tag                          = "b83a460d229464f29afc24babe75eabe8c8813a9"
  masked_appstore_schedule_expression   = "cron(0 5 * * ? *)"
  unmasked_appstore_schedule_expression = "cron(0 5 * * ? *)"

  # Inapp Metrics Inputs
  inapp_metrics_etl_repository_url   = dependency.ecr.outputs.inapp_metrics_etl_repository_url
  inapp_metrics_etl_repository_arn   = dependency.ecr.outputs.inapp_metrics_etl_repository_arn
  inapp_tag                          = "b83a460d229464f29afc24babe75eabe8c8813a9"
  inapp_metrics_cpu_units            = 2048
  inapp_metrics_memory               = 16384
  masked_inapp_schedule_expression   = "cron(0 3 * * ? *)"
  unmasked_inapp_schedule_expression = "cron(0 4 * * ? *)"
  aggregate_metrics_table_arn        = dependency.dynamodb.outputs.aggregate_metrics_arn

  # Common Inputs
  billing_tag_key         = "CostCentre"
  billing_tag_value       = "CovidShield"
  subnet_id               = dependency.network.outputs.private_subnet_id
  sg_id                   = dependency.network.outputs.csv_etl_sg_id
  unmasked_metrics_s3_arn = dependency.s3.outputs.unmasked_metrics_arn
  masked_metrics_s3_arn   = dependency.s3.outputs.masked_metrics_arn
  masked_metrics_bucket   = dependency.s3.outputs.masked_metrics_id
  unmasked_metrics_bucket = dependency.s3.outputs.unmasked_metrics_id
  sns_topic_warning_name  = "alert-warning"
}

terraform {
  source = "git::https://github.com/cds-snc/covid-alert-metrics-terraform//aws/ecs?ref=v${get_env("INFRASTRUCTURE_VERSION")}"
}
