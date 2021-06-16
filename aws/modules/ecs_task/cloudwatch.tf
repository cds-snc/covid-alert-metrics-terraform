resource "aws_cloudwatch_event_rule" "event_rule" {
  name                = "${var.name}_event_rule"
  schedule_expression = var.event_rule_schedule_expression
  role_arn            = var.task_execution_role_arn
  tags = {
    Name = "${var.name}-cw-event-rule"
  }
}


resource "aws_cloudwatch_event_target" "ecs_scheduled_task" {
  rule           = aws_cloudwatch_event_rule.event_rule.name
  event_bus_name = aws_cloudwatch_event_rule.event_rule.event_bus_name
  arn            = var.cluster_id
  role_arn       = var.container_execution_role_arn 

  ecs_target {
    launch_type         = "FARGATE"
    platform_version    = "1.4.0"
    task_count          = 1
    task_definition_arn = aws_ecs_task_definition.task_def.arn

    network_configuration {
      subnets          = [var.subnet_id]
      security_groups  = [var.sg_id]
    }
  }
}