resource "aws_iam_role" "metrics_api_gateway_cloudwatch_role" {
  name               = "metrics_api_gateway_cloudwatch_role"
  assume_role_policy = data.aws_iam_policy_document.service_principal.json
}

data "aws_iam_policy_document" "service_principal" {
  statement {
    effect = "Allow"

    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["apigateway.amazonaws.com"]
    }
  }
}

resource "aws_iam_role_policy_attachment" "metrics_api_gateway_cloudwatch" {
  role       = aws_iam_role.metrics_api_gateway_cloudwatch_role.name
  policy_arn = aws_iam_policy.metrics_apigateway_cloudwatch.arn
}

data "aws_iam_policy_document" "cloudwatch" {
  statement {
    effect = "Allow"

    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:DescribeLogGroups",
      "logs:DescribeLogStreams",
      "logs:PutLogEvents",
      "logs:GetLogEvents",
      "logs:FilterLogEvents"
    ]

    resources = ["*"]
  }

}

resource "aws_iam_policy" "metrics_apigateway_cloudwatch" {
  name   = "MetricsApigatewayCloudwatch"
  path   = "/"
  policy = data.aws_iam_policy_document.cloudwatch.json
}
