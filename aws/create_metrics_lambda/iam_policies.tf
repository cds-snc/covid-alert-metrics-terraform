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

resource "aws_iam_role_policy_attachment" "createmetrics_s3_put" {
  role       = aws_iam_role.create_metrics.name
  policy_arn = aws_iam_policy.create_metrics_put_s3.arn
}

# Use AWS managed IAM policy
####
# Provides minimum permissions for a Lambda function to execute while 
# accessing a resource within a VPC - create, describe, delete network 
# interfaces and write permissions to CloudWatch Logs.
####
resource "aws_iam_role_policy_attachment" "AWSLambdaVPCAccessExecutionRole" {
  role       = aws_iam_role.create_metrics.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaVPCAccessExecutionRole"
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

# create_metrics_put_s3

data "aws_iam_policy_document" "create_metrics_put_s3" {
  statement {
    effect = "Allow"
    actions = [
      "s3:PutObject",
      "s3:PutObjectAcl",
    ]
    resources = [
      var.metrics_error_log_s3_arn,
      "${var.metrics_error_log_s3_arn}/*"
    ]
  }

}

resource "aws_iam_policy" "create_metrics_put_s3" {
  name   = "CovidAlertCreateMetricsPutItem"
  path   = "/"
  policy = data.aws_iam_policy_document.create_metrics_put_s3.json
}

