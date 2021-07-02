
resource "aws_ecr_repository" "create_csv" {
  # checkov:skip=CKV_AWS_51:The :latest tag is used in Staging
  # checkov:skip=CKV_AWS_136:Using default service key for encryption is acceptable
  name                 = "covid-server/metrics-server"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}

resource "aws_ecr_repository" "server_metrics_etl" {
  # checkov:skip=CKV_AWS_51:The :latest tag is used in Staging
  # checkov:skip=CKV_AWS_136:Using default service key for encryption is acceptable
  name                 = "covid-server/server-metrics-etl"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}

resource "aws_ecr_repository" "appstore_metrics_etl" {
  # checkov:skip=CKV_AWS_51:The :latest tag is used in Staging
  # checkov:skip=CKV_AWS_136:Using default service key for encryption is acceptable
  name                 = "covid-server/appstore-metrics-etl"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}