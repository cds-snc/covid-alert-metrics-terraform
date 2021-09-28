resource "aws_security_group" "create_metrics_sg" {
  name        = "create_metrics_sg"
  description = "Allow TLS outbound traffic to S3"
  vpc_id      = data.aws_vpc.covid_alert.id
  egress {
    from_port       = 443
    to_port         = 443
    protocol        = "tcp"
    prefix_list_ids = [data.aws_vpc_endpoint.dynamodb.prefix_list_id, data.aws_vpc_endpoint.s3.prefix_list_id]
  }
}
