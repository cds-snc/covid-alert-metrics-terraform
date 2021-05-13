dependencies {
  paths = ["../ecr", "../network", "../s3"]
}


dependency "network" {
  config_path = "../network"

  mock_outputs_allowed_terraform_commands = ["validate", "plan"]
  mock_outputs = {
    csv_etl_sg_id     = ""
    private_subnet_id = ""
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

  csv_etl_repository_url    = dependency.ecr.outputs.create_csv_repository_url
  csv_etl_tag               = "latest"
  create_csv_repository_arn = dependency.ecr.outputs.create_csv_repository_arn

  csv_etl_sg_id             = dependency.network.outputs.csv_etl_sg_id
  metrics_private_subnet_id = dependency.network.outputs.private_subnet_id

  unmasked_metrics_s3_arn = dependency.s3.outputs.unmasked_metrics_arn
  masked_metrics_s3_arn   = dependency.s3.outputs.masked_metrics_arn
  masked_metrics_bucket   = dependency.s3.outputs.masked_metrics_id
  unmasked_metrics_bucket = dependency.s3.outputs.unmasked_metrics_id
  memory_size = 1024

  masked_metrics_environment_variables = {
    ENV = "staging"
  }

  unmasked_metrics_environment_variables = {
    ENV = "staging"
  }

}

include {
  path = find_in_parent_folders()
}

terraform {
  source = "../../../aws//etl_lambdas"
}
