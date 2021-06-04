
resource "aws_security_group" "lambda" {
  # checkov:skip=CKV2_AWS_5:Used as a source_security_group_id by other SG rules

  description = "Used by lamba for access to the internet and the S3/DynamoDB private endpoints"
  vpc_id      = aws_vpc.main.id

  tags = {
    Name = "${var.name}_lambda_sg"
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group_rule" "inet_egress" {
  description       = "Allow lambda egress to the internet"
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.lambda.id
}

resource "aws_security_group_rule" "efs_egress" {
  description              = "Allow lambda to egress to efs"
  type                     = "egress"
  to_port                  = 2049
  from_port                = 2049
  protocol                 = "tcp"
  security_group_id        = aws_security_group.lambda.id
  source_security_group_id = aws_security_group.efs.id
}
