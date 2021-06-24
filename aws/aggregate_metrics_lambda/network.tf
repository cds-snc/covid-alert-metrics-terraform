resource "aws_security_group" "aggregate_metrics_sg" {
  name        = "aggregate_metrics_sg"
  description = "Allow TLS outbound traffic to dynamodb"
  vpc_id      = data.aws_vpc.covid_alert.id
  egress {
    from_port       = 443
    to_port         = 443
    protocol        = "tcp"
    prefix_list_ids = [data.aws_vpc_endpoint.dynamodb.prefix_list_id]
    security_groups = [data.aws_security_group.privatelink.id]
  }
}