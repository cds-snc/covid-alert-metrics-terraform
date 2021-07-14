data "aws_api_gateway_rest_api" "metrics" {
  name = var.metrics_api_gateway_name
}

data "aws_sns_topic" "alert_warning" {
  name = var.sns_topic_warning_name
}

data "aws_sns_topic" "alert_critical" {
  name = var.sns_topic_critical_name
}

data "aws_dynamodb_table" "raw_metrics" {
  name = "raw_metrics"
}

data "aws_dynamodb_table" "aggregate_metrics" {
  name = "aggregate_metrics"
}
