dependencies {
  paths = ["../ecr", "../network", "../s3"]
}


dependency "network" { 
  config_path = "../network"
}

dependency "ecr" { 
  config_path = "../ecr"
}

dependency "s3" { 
  config_path = "../s3"
}

inputs = { 

  vpc_networking_policy = dependency.network.outputs.vpc_networking_policy
  write_csv_buckets_arn = dependency.s3.outputs.write_s3_csv_buckets
  pull_csv_image_arn = dependency.ecr.outputs.create_csv_pull_policy

  csv_etl_repository_url = dependency.outputs.create_csv_repository_url
  csv_etl_tag = "latest"

  csv_etl_sg_id = dependency.network.outputs.csv_etl_sg_id
  metrics_private_subnet_id = dependency.network.outputs.private_subnet_id

  masked_metrics_bucket = dependency.s3.outputs.masked_metrics_bucket
  unmasked_metrics_bucket = dependency.s3.outputes.unmasked_metrics_bucket
}

include {
  path = find_in_parent_folders()
}

terraform {
  source = "../../../aws//etl_lambdas"
}
