data "aws_acm_certificate" "covidshield" {
  domain = var.route53_zone_name
}

data "aws_route53_zone" "covidshield" {
  name = var.route53_zone_name
}
