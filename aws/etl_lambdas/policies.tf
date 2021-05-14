resource "aws_iam_role" "metrics_csv" {
  name               = "metrics_csv_lambda_role"
  assume_role_policy = data.aws_iam_policy_document.service_principal.json
}

resource "aws_iam_role_policy_attachment" "etl_policies" {
  role       = aws_iam_role.metrics_csv.name
  policy_arn = aws_iam_policy.etl_policies.arn
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

data "aws_dynamodb_table" "aggregate_metrics" {
  name = "aggregate_metrics"
}

data "aws_iam_policy_document" "etl_policies" {

  statement {

    sid = "Allow lambdas to read dynamodb table aggregate_metrics"

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

    sid = "Allow lambda to pull container images"

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

    sid = "Allow lambdas to write to logs"

    effect = "Allow"

    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]

    resources = [
      "*"
    ]
  }

  statement {

    sid = "Allow lambda to create network interfaces"

    effect = "Allow"

    actions = [
      "ec2:CreateNetworkInterface",
      "ec2:DescribeNetworkInterfaces",
      "ec2:DeleteNetworkInterface"
    ]

    resources = [
      "*"
    ]

  }

  statement {

    sid = "Allow lambda to write to S3 Buckets"

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
