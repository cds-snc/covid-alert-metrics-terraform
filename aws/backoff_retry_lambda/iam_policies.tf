resource "aws_iam_role" "backoff" {
  name               = "backoff_lambda_role"
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

resource "aws_iam_role_policy_attachment" "backoff_retry" {
  role       = aws_iam_role.backoff.name
  policy_arn = aws_iam_policy.backoff_retry.arn
}

resource "aws_iam_policy" "backoff_retry" {
  name   = "CovidAlertBackoffRetryLambda"
  path   = "/"
  policy = data.aws_iam_policy_document.backoff_retry.json
}

data "aws_iam_policy_document" "backoff_retry" {

  statement {
    effect = "Allow"

    actions = [
      "dynamodb:UpdateItem"
    ]

    resources = [
      var.aggregate_metrics_arn
    ]
  }

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

  statement {

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

    effect = "Allow"
    actions = [
      "kms:GenerateDataKey",
      "kms:Decrypt",
      "sqs:SendMessage",
      "sqs:ReceiveMessage",
      "sqs:DeleteMessage",
      "sqs:GetQueueAttributes"

    ]
    resources = [
      var.metrics_key_arn,
      var.dead_letter_queue_arn
    ]

  }

}
