data "aws_vpc" "covid_alert" {
  filter {
    name   = "tag:Name"
    values = ["CovidShield"]
  }
}

data "aws_vpc_endpoint" "dynamodb" {
  vpc_id       = data.aws_vpc.covid_alert.id
  service_name = "com.amazonaws.${var.region}.dynamodb"
}

data "aws_security_group" "privatelink" {
  name   = "privatelink"
  vpc_id = data.aws_vpc.covid_alert.id
}

data "aws_subnet_ids" "private" {
  vpc_id = data.aws_vpc.covid_alert.id

  tags = {
    Access = "private"
  }
}

data "aws_sns_topic" "alert_critical" {
  name = "alert-critical"
}