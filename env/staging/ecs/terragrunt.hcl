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
    create_csv_repository_url = ""
    create_csv_repository_arn = ""
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
  subnet_id                           = dependency.network.outputs.private_subnet_id
  sg_id                               = dependency.network.outputs.csv_etl_sg_id
  unmasked_metrics_s3_arn             = dependency.s3.outputs.unmasked_metrics_arn
  masked_metrics_s3_arn               = dependency.s3.outputs.masked_metrics_arn
  masked_metrics_bucket               = dependency.s3.outputs.masked_metrics_id
  unmasked_metrics_bucket             = dependency.s3.outputs.unmasked_metrics_id
  csv_etl_repository_url              = dependency.ecr.outputs.create_csv_repository_url
  create_csv_repository_arn           = dependency.ecr.outputs.create_csv_repository_arn
  server_metrics_etl_repository_url   = dependency.ecr.outputs.server_metrics_etl_repository_url
  server_metrics_etl_repository_arn   = dependency.ecr.outputs.server_metrics_etl_repository_arn
  appstore_metrics_etl_repository_url = dependency.ecr.outputs.appstore_metrics_etl_repository_url
  appstore_metrics_etl_repository_arn = dependency.ecr.outputs.appstore_metrics_etl_repository_arn
  billing_tag_key                     = "CostCentre"
  billing_tag_value                   = "CovidShield"
  masked_image_tag                    = "latest"
  unmasked_image_tag                  = "latest"
  masked_server_tag                   = "latest"
  unmasked_server_tag                 = "latest"
  masked_appstore_tag                 = "latest"
  unmasked_appstore_tag               = "latest"
  cpu_units                           = 512
  memory                              = 1024
  aggregate_metrics_table_arn         = dependency.dynamodb.outputs.aggregate_metrics_arn
  schedule_expression                 = "rate(24 hours)"
  metrics_token                       = "${get_env("TF_VAR_METRICS_TOKEN")}"
}

terraform {
  source = "../../../aws//ecs"
}
