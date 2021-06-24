resource "aws_iam_role" "aggregator" {
  name               = "aggregate_lambda_role"
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

resource "aws_iam_role_policy_attachment" "aggregator_update" {
  role       = aws_iam_role.aggregator.name
  policy_arn = aws_iam_policy.aggregate_metrics_update.arn
}

resource "aws_iam_role_policy_attachment" "aggregator_log_writer" {
  role       = aws_iam_role.aggregator.name
  policy_arn = aws_iam_policy.write_logs.arn
}

resource "aws_iam_role_policy_attachment" "aggregator_vpc_networking" {
  role       = aws_iam_role.aggregator.name
  policy_arn = aws_iam_policy.vpc_networking.arn
}

resource "aws_iam_role_policy_attachment" "aggregator_raw_metrics_stream_processor" {
  role       = aws_iam_role.aggregator.name
  policy_arn = aws_iam_policy.raw_metrics_stream_processor.arn
}

resource "aws_iam_role_policy_attachment" "aggregator_write_and_encrypt_deadletter_queue" {
  role       = aws_iam_role.aggregator.name
  policy_arn = aws_iam_policy.write_and_encrypt_deadletter_queue.arn
}

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

# dynamodb_streams

data "aws_iam_policy_document" "raw_metrics_stream_processor" {
  statement {

    effect = "Allow"
    actions = [
      "dynamodb:DescribeStream",
      "dynamodb:GetRecords",
      "dynamodb:GetShardIterator",
      "dynamodb:ListStreams",
      "dyanmodb:ListShards"
    ]
    resources = [
      var.raw_metrics_stream_arn
    ]
  }

}

resource "aws_iam_policy" "raw_metrics_stream_processor" {
  name   = "CovidAlertRawMetricsStreamProcessor"
  path   = "/"
  policy = data.aws_iam_policy_document.raw_metrics_stream_processor.json
}

# Write and encrypt to SQS deadletter queue

data "aws_iam_policy_document" "write_and_encrypt_deadletter_queue" {
  statement {

    effect = "Allow"
    actions = [
      "kms:GenerateDataKey",
      "kms:Decrypt",
      "sqs:SendMessage"

    ]
    resources = [
      var.metrics_key_arn,
      var.dead_letter_queue_arn
    ]

  }
}

resource "aws_iam_policy" "write_and_encrypt_deadletter_queue" {
  name   = "CovidAlertWriteAndEncryptDeadletterQueue"
  path   = "/"
  policy = data.aws_iam_policy_document.write_and_encrypt_deadletter_queue.json
}
