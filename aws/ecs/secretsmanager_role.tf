resource "aws_secretsmanager_secret" "metrics_token" {
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


