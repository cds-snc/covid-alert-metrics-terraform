locals {
  masked_server_image   = "${var.server_metrics_etl_repository_url}:${var.server_tag}"
  unmasked_server_image = "${var.server_metrics_etl_repository_url}:${var.server_tag}"
}

module "masked_server_metrics_etl" {
  source                         = "../modules/ecs_task"
  name                           = "masked_server_metrics"
  cpu_units                      = var.server_metrics_cpu_units
  memory                         = var.server_metrics_memory
  container_execution_role_arn   = aws_iam_role.server_metrics_container_execution_role.arn
  task_execution_role_arn        = aws_iam_role.server_appstore_task_execution_role.arn
  scheduled_task_role_arn        = aws_iam_role.scheduled_task_cw_event_role.arn
  billing_tag_key                = var.billing_tag_key
  billing_tag_value              = var.billing_tag_value
  cluster_id                     = aws_ecs_cluster.in_app_metrics.id
  subnet_id                      = var.subnet_id
  sg_id                          = var.sg_id
  template_file                  = file("task-definitions/server_metrics.json")
  event_rule_schedule_expression = var.masked_server_schedule_expression
  vars = {
    image                   = local.masked_server_image
    awslogs-region          = "ca-central-1"
    awslogs-stream-prefix   = "ecs-masked-server-metrics"
    mask_data               = "True"
    environment             = var.env
    bucket_name             = var.masked_metrics_bucket
    metric_token_secret_arn = aws_secretsmanager_secret.metrics_token.id
    server_events_endpoint  = var.server_events_endpoint
  }
  log_retention_in_days = var.log_retention_in_days
  ecs_task_alarm_action = data.aws_sns_topic.alert_warning.arn
}

module "unmasked_server_metrics_etl" {
  source                         = "../modules/ecs_task"
  name                           = "unmasked_server_metrics"
  cpu_units                      = var.server_metrics_cpu_units
  memory                         = var.server_metrics_memory
  container_execution_role_arn   = aws_iam_role.server_metrics_container_execution_role.arn
  task_execution_role_arn        = aws_iam_role.server_appstore_task_execution_role.arn
  scheduled_task_role_arn        = aws_iam_role.scheduled_task_cw_event_role.arn
  billing_tag_key                = var.billing_tag_key
  billing_tag_value              = var.billing_tag_value
  cluster_id                     = aws_ecs_cluster.in_app_metrics.id
  subnet_id                      = var.subnet_id
  sg_id                          = var.sg_id
  template_file                  = file("task-definitions/server_metrics.json")
  event_rule_schedule_expression = var.unmasked_server_schedule_expression
  vars = {
    image                   = local.unmasked_server_image
    awslogs-region          = "ca-central-1"
    awslogs-stream-prefix   = "ecs-unmasked-server-metrics"
    mask_data               = "False"
    environment             = var.env
    bucket_name             = var.unmasked_metrics_bucket
    metric_token_secret_arn = aws_secretsmanager_secret.metrics_token.id
    server_events_endpoint  = var.server_events_endpoint
  }
  log_retention_in_days = var.log_retention_in_days
  ecs_task_alarm_action = data.aws_sns_topic.alert_warning.arn
}
