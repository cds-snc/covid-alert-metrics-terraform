
resource "aws_iam_role" "task_execution_role" {
  name               = "metrics_task_execution_role"
  assume_role_policy = data.aws_iam_policy_document.task_execution_role.json
}

resource "aws_iam_role" "server_appstore_task_execution_role" {
  name               = "server_appstore_metrics_task_execution_role"
  assume_role_policy = data.aws_iam_policy_document.task_execution_role.json
}

resource "aws_iam_role_policy_attachment" "readonly_table_te_etl_policies" {
  role       = aws_iam_role.task_execution_role.name
  policy_arn = aws_iam_policy.readonly_aggregate_metrics.arn
}

resource "aws_iam_policy" "readonly_aggregate_metrics" {
  name   = "ReadOnlyTableTaskExecutionPolicies"
  path   = "/"
  policy = data.aws_iam_policy_document.readonly_aggregate_metrics.json
}

resource "aws_iam_policy" "etl_policies" {
  name   = "ETLTaskExecutionPolicies"
  path   = "/"
  policy = data.aws_iam_policy_document.etl_policies.json
}

resource "aws_iam_role_policy_attachment" "te_etl_policies" {
  role       = aws_iam_role.task_execution_role.name
  policy_arn = aws_iam_policy.etl_policies.arn
}

resource "aws_iam_role_policy_attachment" "secretsmanager_etl_policies" {
  role       = aws_iam_role.task_execution_role.name
  policy_arn = aws_iam_policy.get_metrics_token_secret_value_ecs_task.arn
}

resource "aws_iam_role_policy_attachment" "server_appstore_te_etl_policies" {
  role       = aws_iam_role.server_appstore_task_execution_role.name
  policy_arn = aws_iam_policy.etl_policies.arn
}
