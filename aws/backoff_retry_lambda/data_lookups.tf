data "aws_vpc" "covid_alert" {
  id = "vpc-06fbc7337b116cce1"
}

data "aws_vpc_endpoint" "dynamodb" {
  vpc_id       = data.aws_vpc.covid_alert.id
  service_name = "com.amazonaws.${var.region}.dynamodb"
}

data "aws_security_group" "privatelink" {
  id = "sg-0e0070c8141ce36a5"
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