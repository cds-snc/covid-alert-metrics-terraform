###
# Route53 Record - Metrics Submission
###

resource "aws_route53_record" "covidshield_metrics_submission" {
  zone_id = data.aws_route53_zone.covidshield.zone_id
  name    = "metrics.${data.aws_route53_zone.covidshield.name}"
  type    = "A"

  alias {
    name                   = aws_api_gateway_domain_name.metrics.regional_domain_name
    zone_id                = aws_api_gateway_domain_name.metrics.regional_zone_id
    evaluate_target_health = false
  }
}
