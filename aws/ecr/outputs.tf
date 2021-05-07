output "create_csv_repository_url" { 
  value = aws_ecr_repository.create_csv.repository_url
}

output "create_csv_repository_arn" { 
  value = aws_ecr_repository.create_csv.arn
}