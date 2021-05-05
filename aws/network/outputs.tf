output "vpc_networking_policy" { 
  value = aws_iam_policy.vpc_networking.arn
}

output "csv_etl_sg_id" { 
  value = aws_security_group.lambda.id
}

output "private_subnet_id" { 
  value = aws_subnet.private.id
}