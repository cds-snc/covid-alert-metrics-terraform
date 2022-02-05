resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "${var.name}_vpc"
  }

}

resource "aws_nat_gateway" "nat_gateway" {

  allocation_id = aws_eip.lambda.id
  subnet_id     = aws_subnet.public.id

  tags = {
    Name = "${var.name}-natgw"
  }

  depends_on = [
    aws_internet_gateway.gw
  ]
}

resource "aws_eip" "lambda" {
  # checkov:skip=CKV2_AWS_19:EIP is used by NAT Gateway
  vpc = true
}

resource "aws_subnet" "private" {

  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.name}_private_subnet"
  }
  availability_zone = "ca-central-1a"
  cidr_block        = "10.0.1.0/24"

  timeouts {
    delete = "40m"
  }
  depends_on = [data.aws_iam_policy.CovidAlertBackoffRetryLambda]
}

resource "aws_subnet" "public" {

  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.name}_public_subnet"
  }

  cidr_block = "10.0.0.0/24"
}

resource "aws_internet_gateway" "gw" {

  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.name}_internet_gateway"
  }

}

resource "aws_default_security_group" "default" {
  vpc_id = aws_vpc.main.id
}

resource "aws_flow_log" "cloud_based_sensor" {
  log_destination      = "arn:aws:s3:::${var.cbs_satellite_bucket_name}/vpc_flow_logs/"
  log_destination_type = "s3"
  traffic_type         = "ALL"
  vpc_id               = aws_vpc.main.id
  log_format           = "$${vpc-id} $${version} $${account-id} $${interface-id} $${srcaddr} $${dstaddr} $${srcport} $${dstport} $${protocol} $${packets} $${bytes} $${start} $${end} $${action} $${log-status} $${subnet-id} $${instance-id}"

  tags = {
    (var.billing_tag_key) = var.billing_tag_value
    Terraform             = true
    CloudBasedSensor      = true
  }
}
