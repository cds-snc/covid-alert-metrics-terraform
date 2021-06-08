resource "aws_flow_log" "vpc_metrics_flow_logs" {
  iam_role_arn    = aws_iam_role.vpc_metrics_flow_logs.arn
  log_destination = aws_cloudwatch_log_group.vpc_metrics_flow_logs.arn
  traffic_type    = "ALL"
  vpc_id          = aws_vpc.main.id
}

resource "aws_cloudwatch_log_group" "vpc_metrics_flow_logs" {
  # checkov:skip=CKV_AWS_158:Encryption using default CloudWatch service key is acceptable
  name              = "vpc_metrics_flow_logs"
  retention_in_days = 30
}

resource "aws_iam_role" "vpc_metrics_flow_logs" {
  name               = "vpc_metrics_flow_logs"
  assume_role_policy = data.aws_iam_policy_document.vpc_flow_logs_service_principal.json
}

resource "aws_iam_policy" "vpc_metrics_flow_logs_write" {
  name   = "CovidAlertMetricsVpcFlowLogs"
  policy = data.aws_iam_policy_document.vpc_metrics_flow_logs_write.json
}

resource "aws_iam_role_policy_attachment" "vpc_metrics_flow_logs_write" {
  role       = aws_iam_role.vpc_metrics_flow_logs.name
  policy_arn = aws_iam_policy.vpc_metrics_flow_logs_write.arn
}

data "aws_iam_policy_document" "vpc_flow_logs_service_principal" {
  statement {
    effect = "Allow"

    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["vpc-flow-logs.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "vpc_metrics_flow_logs_write" {

  statement {
    effect = "Allow"

    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
      "logs:DescribeLogGroups",
      "logs:DescribeLogStreams"
    ]

    resources = [
      aws_cloudwatch_log_group.vpc_metrics_flow_logs.arn,
      "${aws_cloudwatch_log_group.vpc_metrics_flow_logs.arn}/*"
    ]
  }
}
