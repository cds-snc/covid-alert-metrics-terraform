data "aws_iam_policy_document" "scheduled_task_cw_event_role_assume_role_policy" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]
    principals {
      identifiers = ["events.amazonaws.com"]
      type        = "Service"
    }
  }
}

data "aws_iam_policy_document" "scheduled_task_cw_event_role_cloudwatch_policy" {
  statement {
    effect    = "Allow"
    actions   = ["ecs:RunTask"]
    resources = ["*"]
  }
  statement {
    actions   = ["iam:PassRole"]
    resources = [aws_iam_role.task_execution_role]
  }
}

resource "aws_iam_role" "scheduled_task_cw_event_role" {
  name               = "etl-st-cw-role"
  assume_role_policy = data.aws_iam_policy_document.scheduled_task_cw_event_role_assume_role_policy.json
}

resource "aws_iam_role_policy" "scheduled_task_cw_event_role_cloudwatch_policy" {
  name   = "etl-st-cw-policy"
  role   = aws_iam_role.scheduled_task_cw_event_role.id
  policy = data.aws_iam_policy_document.scheduled_task_cw_event_role_cloudwatch_policy.json
}