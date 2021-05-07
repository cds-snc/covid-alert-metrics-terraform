module "unmasked_metrics" {
  
  source = "../modules/lambda"
  name = "unmasked_metrics"
  repository_url = var.csv_etl_repository_url
  tag = var.csv_etl_tag
  role_arn = aws_iam_role.metrics_csv.arn
  timeout = 900
  security_group_id = var.csv_etl_sg_id
  subnet_id = var.metrics_private_subnet_id

  env_variables = {
    MASK_DATA = "false"
    BUCKET_NAME = var.unmasked_metrics_bucket
  }

}

module "masked_metrics" {

  source = "../modules/lambda"
  name = "masked_metrics"
  repository_url = var.csv_etl_repository_url
  tag = var.csv_etl_tag
  role_arn = aws_iam_role.metrics_csv.arn
  timeout = 900
  security_group_id = var.csv_etl_sg_id
  subnet_id = var.metrics_private_subnet_id

  env_variables = {
    MASK_DATA = "true"
    BUCKET_NAME = var.masked_metrics_bucket
  }

}