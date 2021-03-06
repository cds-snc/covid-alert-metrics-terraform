output "csv_etl_sg_id" {
  value = aws_security_group.lambda.id
}

output "efs_sg_id" {
  value = aws_security_group.efs.id
}

output "private_subnet_id" {
  value = aws_subnet.private.id
}