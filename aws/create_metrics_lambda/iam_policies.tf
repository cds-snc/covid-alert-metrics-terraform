resource "aws_iam_role" "create_metrics" {
  name               = "create_lambda_role"
  assume_role_policy = data.aws_iam_policy_document.service_principal.json
}

data "aws_iam_policy_document" "service_principal" {
  statement {
    effect = "Allow"

    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

resource "aws_iam_role_policy_attachment" "createmetrics_dynamodb_put" {
  role       = aws_iam_role.create_metrics.name
  policy_arn = aws_iam_policy.create_metrics_put.arn
}

resource "aws_iam_role_policy_attachment" "create_metrics_log_writer" {
  role       = aws_iam_role.create_metrics.name
  policy_arn = aws_iam_policy.write_logs.arn
}

resource "aws_iam_role_policy_attachment" "createmetrics_vpc_networking" {
  role       = aws_iam_role.create_metrics.name
  policy_arn = aws_iam_policy.vpc_networking.arn
}

# create_metrics_put

data "aws_iam_policy_document" "create_metrics_put" {
  statement {
    effect = "Allow"

    actions = [
      "dynamodb:PutItem"
    ]

    resources = [
      data.aws_dynamodb_table.raw_metrics.arn
    ]
  }

}

resource "aws_iam_policy" "create_metrics_put" {
  name   = "CovidAlertCreateMetricsPutItem"
  path   = "/"
  policy = data.aws_iam_policy_document.create_metrics_put.json
}

# write_logs

data "aws_iam_policy_document" "write_logs" {
  statement {

    effect = "Allow"

    actions = [
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]

    resources = [
      "arn:aws:logs:*:*:*"
    ]
  }
}

resource "aws_iam_policy" "write_logs" {
  name   = "CovidAlertLogWriter"
  path   = "/"
  policy = data.aws_iam_policy_document.write_logs.json
}

# vpc_networking

data "aws_iam_policy_document" "vpc_networking" {
  statement {

    effect = "Allow"

    actions = [
      "ec2:CreateNetworkInterface",
      "ec2:DescribeNetworkInterfaces",
      "ec2:DeleteNetworkInterface"
    ]

    resources = [
      "arn:aws:ec2:${var.region}:${var.account_id}:network-interface/*"
    ]

  }
}

resource "aws_iam_policy" "vpc_networking" {
  name   = "CovidAlertVplNetworking"
  path   = "/"
  policy = data.aws_iam_policy_document.vpc_networking.json
}
