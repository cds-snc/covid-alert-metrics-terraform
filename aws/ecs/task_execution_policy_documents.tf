
data "aws_iam_policy_document" "readonly_aggregate_metrics" {

  statement {

    effect = "Allow"

    actions = [
      "dynamodb:GetItem",
      "dynamodb:BatchGetItem",
      "dynamodb:Scan",
      "dynamodb:Query",
      "dynamodb:ConditionCheckItem"
    ]
    resources = [
      var.aggregate_metrics_table_arn
    ]

  }
}

data "aws_iam_policy_document" "task_execution_role" {
  statement {
    effect = "Allow"

    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "server_metrics_task_execution_role" {
  statement {
    effect = "Allow"

    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "etl_policies" {

  statement {

    effect = "Allow"

    actions = [
      "ecr:GetDownloadUrlForlayer",
      "ecr:BatchGetImage"
    ]
    resources = [
      var.create_csv_repository_arn,
      var.appstore_metrics_etl_repository_arn,
      var.server_metrics_etl_repository_arn
    ]
  }

  statement {

    effect = "Allow"

    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]

    resources = [
      module.masked_metrics.log_group_arn,
      module.unmasked_metrics.log_group_arn,
      "${module.masked_metrics.log_group_arn}:log-stream:*",
      "${module.unmasked_metrics.log_group_arn}:log-stream:*",
      module.masked_server_metrics_etl.log_group_arn,
      module.unmasked_server_metrics_etl.log_group_arn,
      "${module.masked_server_metrics_etl.log_group_arn}:log-stream:*",
      "${module.unmasked_server_metrics_etl.log_group_arn}:log-stream:*",
      module.masked_appstore_metrics_etl.log_group_arn,
      module.unmasked_appstore_metrics_etl.log_group_arn,
      "${module.masked_appstore_metrics_etl.log_group_arn}:log-stream:*",
      "${module.unmasked_appstore_metrics_etl.log_group_arn}:log-stream:*"
    ]
  }

  statement {

    effect = "Allow"

    actions = [
      "ec2:CreateNetworkInterface",
      "ec2:DeleteNetworkInterface"
    ]

    resources = [
      "arn:aws:ec2:${var.region}:${var.account_id}:network-interface/*"
    ]

  }

  statement {

    effect = "Allow"

    actions = [
      "ec2:DescribeNetworkInterfaces"
    ]

    resources = [
      "*"
    ]

  }

  statement {

    effect = "Allow"
    actions = [
      "s3:PutObject",
      "s3:PutObjectAcl",
    ]
    resources = [
      var.unmasked_metrics_s3_arn,
      "${var.unmasked_metrics_s3_arn}/*",
      var.masked_metrics_s3_arn,
      "${var.masked_metrics_s3_arn}/*"
    ]

  }

}

data "aws_iam_policy_document" "get_metrics_token_secret_value_ecs_task" {
  statement {
    effect    = "Allow"
    actions   = ["secretsmanager:GetSecretValue"]
    resources = [aws_secretsmanager_secret.metrics_token.arn]
  }
}
