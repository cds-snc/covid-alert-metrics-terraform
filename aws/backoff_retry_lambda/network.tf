
resource "aws_security_group" "backoff_retry_sg" {
  name        = "backoff_retry_sg"
  description = "Allow TLS outbound traffic to dynamodb"
  vpc_id      = data.aws_vpc.covid_alert.id
  egress {
    from_port       = 443
    to_port         = 443
    protocol        = "tcp"
    prefix_list_ids = [data.aws_vpc_endpoint.dynamodb.prefix_list_id]
  }

  egress {
    from_port       = 443
    to_port         = 443
    protocol        = "tcp"
    security_groups = [data.aws_security_group.privatelink.id]
  }
}

resource "aws_security_group_rule" "privatelink_metrics_backoff_ingress" {
  description              = "Security group rule for metricsRetrieval ingress"
  type                     = "ingress"
  from_port                = 443
  to_port                  = 443
  protocol                 = "tcp"
  security_group_id        = data.aws_security_group.privatelink.id
  source_security_group_id = aws_security_group.backoff_retry_sg.id
}