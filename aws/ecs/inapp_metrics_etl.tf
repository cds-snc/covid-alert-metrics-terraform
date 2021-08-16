locals {
  masked_inapp_metrics_image   = "${var.inapp_metrics_etl_repository_url}:${var.inapp_tag}"
  unmasked_inapp_metrics_image = "${var.inapp_metrics_etl_repository_url}:${var.inapp_tag}"
}

module "masked_inapp_metrics" {
  source                         = "../modules/ecs_task"
  name                           = "masked_inapp_metrics"
  cpu_units                      = var.inapp_metrics_cpu_units
  memory                         = var.inapp_metrics_memory
  task_execution_role_arn        = aws_iam_role.task_execution_role.arn
  container_execution_role_arn   = aws_iam_role.container_execution_role.arn
  scheduled_task_role_arn        = aws_iam_role.scheduled_task_cw_event_role.arn
  billing_tag_key                = var.billing_tag_key
  billing_tag_value              = var.billing_tag_value
  cluster_id                     = aws_ecs_cluster.in_app_metrics.id
  subnet_id                      = var.subnet_id
  sg_id                          = var.sg_id
  template_file                  = file("task-definitions/metrics.json")
  event_rule_schedule_expression = var.masked_inapp_schedule_expression
  vars = {
    image                 = local.masked_inapp_metrics_image
    awslogs-region        = "ca-central-1"
    awslogs-stream-prefix = "ecs-masked-metrics"
    mask_data             = "True"
    environment           = var.env
    bucket_name           = var.masked_metrics_bucket
  }
  log_retention_in_days = var.log_retention_in_days
  ecs_task_alarm_action = data.aws_sns_topic.alert_warning.arn
}

module "unmasked_inapp_metrics" {
  source                         = "../modules/ecs_task"
  name                           = "unmasked_inapp_metrics"
  cpu_units                      = var.inapp_metrics_cpu_units
  memory                         = var.inapp_metrics_memory
  container_execution_role_arn   = aws_iam_role.container_execution_role.arn
  task_execution_role_arn        = aws_iam_role.task_execution_role.arn
  scheduled_task_role_arn        = aws_iam_role.scheduled_task_cw_event_role.arn
  billing_tag_key                = var.billing_tag_key
  billing_tag_value              = var.billing_tag_value
  cluster_id                     = aws_ecs_cluster.in_app_metrics.id
  subnet_id                      = var.subnet_id
  sg_id                          = var.sg_id
  template_file                  = file("task-definitions/metrics.json")
  event_rule_schedule_expression = var.unmasked_inapp_schedule_expression
  vars = {
    image                 = local.unmasked_inapp_metrics_image
    awslogs-region        = "ca-central-1"
    awslogs-stream-prefix = "ecs-unmasked-metrics"
    mask_data             = "False"
    environment           = var.env
    bucket_name           = var.unmasked_metrics_bucket
  }
  log_retention_in_days = var.log_retention_in_days
  ecs_task_alarm_action = data.aws_sns_topic.alert_warning.arn
}
