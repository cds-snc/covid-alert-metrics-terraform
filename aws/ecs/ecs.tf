resource "aws_ecs_cluster" "in_app_metrics" {
  name = "in-app-metrics"

  setting {
    name  = "containerInsights"
    value = "enabled"
  }

  tags = {
    (var.billing_tag_key) = var.billing_tag_value
  }
}
