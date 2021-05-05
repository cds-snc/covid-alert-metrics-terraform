
resource "aws_default_security_group" "default" {
  vpc_id = aws_vpc.main.id
}

resource "aws_security_group" "lambda" {
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
  cidr_blocks       = ["0.0.0.0/0"] #tfsec:ignore:AWS007  required to pull in lambda's data
  security_group_id = aws_security_group.lambda.id
}