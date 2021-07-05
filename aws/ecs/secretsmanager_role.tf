resource "aws_iam_role" "secretsmanager_role" {
  name               = "metrics_secretsmanager_role"
  assume_role_policy = data.aws_iam_policy_document.task_execution_role.json
}

resource "aws_secretsmanager_secret" "metrics_token" {
  # checkov:skip=CKV_AWS_149:AWS Managed keys are acceptable
  name = "server-metrics-token"
}

data "aws_iam_policy_document" "get_metrics_token_secret_value_ecs_task" {
  statement {
    effect    = "Allow"
    actions   = ["secretsmanager:GetSecretValue"]
    resources = [aws_secretsmanager_secret.metrics_token.arn]
  }
}

resource "aws_iam_policy" "get_metrics_token_secret_value_ecs_task" {
  name   = "GetMetricstokenSecretValuePolicies"
  path   = "/"
  policy = data.aws_iam_policy_document.get_metrics_token_secret_value_ecs_task.json
}


