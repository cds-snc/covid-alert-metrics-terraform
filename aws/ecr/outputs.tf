output "create_csv_repository_url" { 
  value = aws_ecr_repository.create_csv.repository_url
}

output "create_csv_pull_policy" { 
  value = aws_iam_policy.pull_create_csv_image_policy.arn
}