data "aws_sns_topic" "alert_warning" {
  name = var.sns_topic_warning_name
}
