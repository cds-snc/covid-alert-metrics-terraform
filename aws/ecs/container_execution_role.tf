resource "aws_iam_role" "container_execution_role" {
  name               = "container_execution_role"
  assume_role_policy = data.aws_iam_policy_document.container_execution_role.json
}

data "aws_iam_policy_document" "container_execution_role" {
  statement {
    effect = "Allow"

    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

resource "aws_iam_role_policy_attachment" "ce_cs" {
  role       = aws_iam_role.container_execution_role.name
  policy_arn = data.aws_iam_policy.ec2_container_service.arn
}

data "aws_iam_policy" "ec2_container_service" {
  name = "AmazonEC2ContainerServiceforEC2Role"
}
