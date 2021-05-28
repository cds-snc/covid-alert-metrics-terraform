# aggregator_metrics_put

data "aws_iam_policy_document" "aggregate_metrics_update" {
  statement {
    effect = "Allow"

    actions = [
      "dynamodb:UpdateItem"
    ]

    resources = [
      var.aggregate_metrics_arn
    ]
  }

}


resource "aws_iam_policy" "aggregate_metrics_update" {
  name   = "CovidAlertAggregateMetricsUpdateItem"
  path   = "/"
  policy = data.aws_iam_policy_document.aggregate_metrics_update.json
}


# assume_role

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
      "*"
    ]

  }
}

resource "aws_iam_policy" "vpc_networking" {
  name   = "CovidAlertVplNetworking"
  path   = "/"
  policy = data.aws_iam_policy_document.vpc_networking.json
}

# Read write and encrypt to deadletter queue
data "aws_iam_policy_document" "read_write_and_encrypt_deadletter_queue" {
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

resource "aws_iam_policy" "read_write_and_encrypt_deadletter_queue" {
  name   = "CovidAlertReadWriteAndEncryptDeadletterQueue"
  path   = "/"
  policy = data.aws_iam_policy_document.read_write_and_encrypt_deadletter_queue.json
}
