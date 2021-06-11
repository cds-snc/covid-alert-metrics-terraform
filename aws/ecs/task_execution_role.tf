
resource "aws_iam_role" "task_execution" {
  name               = "metrics_task_execution_role"
  assume_role_policy = data.aws_iam_policy_document.task_execution_role.json
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

resource "aws_iam_role_policy_attachment" "etl_policies" {
  role       = aws_iam_role.task_execution.name
  policy_arn = aws_iam_policy.etl_policies.arn
}

data "aws_iam_policy_document" "etl_policies" {

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
      data.aws_dynamodb_table.aggregate_metrics.arn
    ]

  }

  statement {

    effect = "Allow"

    actions = [
      "ecr:GetDownloadUrlForlayer",
      "ecr:BatchGetImage"
    ]
    resources = [
      var.create_csv_repository_arn
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
      "${module.unmasked_metrics.log_group_arn}:log-stream:*"
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


resource "aws_iam_policy" "etl_policies" {
  name   = "EtlLambdaAccess"
  path   = "/"
  policy = data.aws_iam_policy_document.etl_policies.json
}
