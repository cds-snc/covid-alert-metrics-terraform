
data "aws_iam_policy_document" "pull_create_csv_image" {
  statement {
    effect = "Allow"
    actions = [
      "ecr:GetDownloadUrlForlayer",
      "ecr:BatchGetImage"
    ]
    resources = [
      aws_ecr_repository.create_csv.arn
    ]
  }
}

resource "aws_iam_policy" "pull_create_csv_image_policy" {
  name   = "CreateCSVPullCreateCSVImage"
  path   = "/"
  policy = data.aws_iam_policy_document.pull_create_csv_image.json
}