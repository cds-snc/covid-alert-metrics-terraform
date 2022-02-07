resource "aws_cloudwatch_event_rule" "event_rule" {
  name                = "${var.name}_event_rule"
  schedule_expression = var.event_rule_schedule_expression
  tags = {
    Name = "${var.name}-cw-event-rule"
  }
}


resource "aws_cloudwatch_event_target" "ecs_scheduled_task" {
  rule           = aws_cloudwatch_event_rule.event_rule.name
  event_bus_name = aws_cloudwatch_event_rule.event_rule.event_bus_name
  arn            = var.cluster_id
  role_arn       = var.scheduled_task_role_arn

  ecs_target {
    launch_type         = "FARGATE"
    platform_version    = "1.4.0"
    task_count          = 1
    task_definition_arn = aws_ecs_task_definition.task_def.arn

    network_configuration {
      subnets         = [var.subnet_id]
      security_groups = [var.sg_id]
    }
  }
}

resource "aws_cloudwatch_log_metric_filter" "ecs_task_error_metric" {
  name           = "EcsTaskError-${var.name}"
  pattern        = "Error"
  log_group_name = aws_cloudwatch_log_group.log.name

  metric_transformation {
    name      = "EcsTaskError-${var.name}"
    namespace = "CovidShieldMetrics"
    value     = "1"
  }
}

resource "aws_cloudwatch_metric_alarm" "ecs_task_error_alarm" {
  alarm_name          = "EcsTaskError-${var.name}"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "1"
  metric_name         = aws_cloudwatch_log_metric_filter.ecs_task_error_metric.name
  namespace           = "CovidShieldMetrics"
  period              = "60"
  statistic           = "Sum"
  threshold           = "0"
  alarm_description   = "This monitors for errors in the ECS ${var.name} task"

  alarm_actions = [var.ecs_task_alarm_action]
}
