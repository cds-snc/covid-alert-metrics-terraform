resource "aws_security_group" "efs" {
  # checkov:skip=CKV2_AWS_5:Used as a source_security_group_id by other SG rules
  description = "Used by EFS"
  vpc_id      = aws_vpc.main.id

  tags = {
    Name = "${var.name}_efs_sg"
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group_rule" "efs_ingress" {
  description              = "Allow communication to EFS from the lambda sg"
  type                     = "ingress"
  from_port                = 2049
  to_port                  = 2049
  protocol                 = "tcp"
  security_group_id        = aws_security_group.efs.id
  source_security_group_id = aws_security_group.lambda.id
}