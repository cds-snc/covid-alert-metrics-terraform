

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
  name   = "${var.name}VpcNetworking"
  path   = "/"
  policy = data.aws_iam_policy_document.vpc_networking.json
}