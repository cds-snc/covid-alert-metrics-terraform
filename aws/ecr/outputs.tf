output "inapp_metrics_etl_repository_url" {
  value = aws_ecr_repository.create_csv.repository_url
}

output "inapp_metrics_etl_repository_arn" {
  value = aws_ecr_repository.create_csv.arn
}

output "server_metrics_etl_repository_url" {
  value = aws_ecr_repository.server_metrics_etl.repository_url
}

output "server_metrics_etl_repository_arn" {
  value = aws_ecr_repository.server_metrics_etl.arn
}

output "appstore_metrics_etl_repository_url" {
  value = aws_ecr_repository.appstore_metrics_etl.repository_url
}

output "appstore_metrics_etl_repository_arn" {
  value = aws_ecr_repository.appstore_metrics_etl.arn
}