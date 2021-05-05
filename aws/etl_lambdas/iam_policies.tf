data "aws_dynamodb_table" "aggregate_metrics" {
  name = "aggregate_metrics"
}

data "aws_iam_policy_document" "aggregate_metrics_read" {
  statement {

    effect = "Allow"
    actions = [
      "dynamodb:GetRecords",
      "dynamodb:GetShardIterator",
      "dyanmodb:ListShards"
    ]
    resources = [
      data.aws_dynamodb_table.aggregate_metrics.arn
    ]

  }

}

resource "aws_iam_policy" "aggregate_metrics_read" {
  name   = "AggregateMetricsRead"
  path   = "/"
  policy = data.aws_iam_policy_document.aggregate_metrics_read.json
}
