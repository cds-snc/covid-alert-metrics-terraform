resource "aws_secretsmanager_secret_version" "metrics_token" {
  secret_id     = aws_secretsmanager_secret.metrics_token.id
  secret_string = var.metrics_token
}

resource "aws_secretsmanager_secret" "metrics_token" {
  # checkov:skip=CKV_AWS_149:AWS Managed keys are acceptable
  name = "server-metrics-token"
}


