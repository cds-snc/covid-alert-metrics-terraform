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

resource "aws_iam_role" "metrics_csv" {
  name               = "metrics_csv_lambda_role"
  assume_role_policy = data.aws_iam_policy_document.service_principal.json
}

resource "aws_iam_role_policy_attachment" "etl_policies" {
  role       = aws_iam_role.metrics_csv.name
  policy_arn = data.aws_iam_policy_document.etl_policies.json
}