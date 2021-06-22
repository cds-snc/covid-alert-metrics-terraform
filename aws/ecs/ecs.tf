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
locals {
  masked_metrics_image   = "${var.csv_etl_repository_url}:${var.masked_image_tag}"
  unmasked_metrics_image = "${var.csv_etl_repository_url}:${var.unmasked_image_tag}"
}
module "masked_metrics" {
  source                         = "../modules/ecs_task"
  name                           = "masked_metrics"
  cpu_units                      = 512
  memory                         = 1024
  task_execution_role_arn        = aws_iam_role.task_execution_role.arn
  container_execution_role_arn   = aws_iam_role.container_execution_role.arn
  scheduled_task_role_arn        = aws_iam_role.scheduled_task_cw_event_role.arn
  billing_tag_key                = var.billing_tag_key
  billing_tag_value              = var.billing_tag_value
  cluster_id                     = aws_ecs_cluster.in_app_metrics.id
  subnet_id                      = var.subnet_id
  sg_id                          = var.sg_id
  template_file                  = file("task-definitions/metrics.json")
  event_rule_schedule_expression = "rate(24 hours)"
  vars = {
    image                 = local.masked_metrics_image
    awslogs-region        = "ca-central-1"
    awslogs-stream-prefix = "ecs-masked-metrics"
    mask_data             = "True"
    environment           = var.env
    bucket_name           = var.masked_metrics_bucket
  }
}

module "unmasked_metrics" {
  source                         = "../modules/ecs_task"
  name                           = "unmasked_metrics"
  cpu_units                      = 512
  memory                         = 1024
  container_execution_role_arn   = aws_iam_role.container_execution_role.arn
  task_execution_role_arn        = aws_iam_role.task_execution_role.arn
  scheduled_task_role_arn        = aws_iam_role.scheduled_task_cw_event_role.arn
  billing_tag_key                = var.billing_tag_key
  billing_tag_value              = var.billing_tag_value
  cluster_id                     = aws_ecs_cluster.in_app_metrics.id
  subnet_id                      = var.subnet_id
  sg_id                          = var.sg_id
  template_file                  = file("task-definitions/metrics.json")
  event_rule_schedule_expression = "rate(24 hours)"
  vars = {
    image                 = local.unmasked_metrics_image
    awslogs-region        = "ca-central-1"
    awslogs-stream-prefix = "ecs-unmasked-metrics"
    mask_data             = "False"
    environment           = var.env
    bucket_name           = var.unmasked_metrics_bucket
  }
}