resource "aws_ecs_task_definition" "task_def" {
  family       = var.name
  cpu          = var.cpu_units
  memory       = var.memory
  network_mode = "awsvpc"

  requires_compatibilities = ["FARGATE"]
  execution_role_arn       = var.container_execution_role_arn
  task_role_arn            = var.task_execution_role_arn
  container_definitions    = data.template_file.masked_metrics.rendered

  tags = {
    (var.billing_tag_key) = var.billing_tag_value
  }
}

resource "aws_cloudwatch_log_group" "log" {
  # checkov:skip=CKV_AWS_158:Encryption using default CloudWatch service key is acceptable
  name              = "/aws/ecs/${var.name}_ecs"
  retention_in_days = 14
}

resource "aws_ecs_service" "service" {

  name             = var.name
  cluster          = var.cluster_id
  task_definition  = aws_ecs_task_definition.task_def.arn
  launch_type      = "FARGATE"
  platform_version = "1.4.0"
  # Enable the new ARN format to propagate tags to containers (see config/terraform/aws/README.md)
  propagate_tags = "SERVICE"

  desired_count                      = 1
  deployment_minimum_healthy_percent = 50
  deployment_maximum_percent         = 200

  network_configuration {
    assign_public_ip = false
    subnets          = [var.subnet_id]
    security_groups = [
      var.sg_id
    ]
  }

  tags = {
    (var.billing_tag_key) = var.billing_tag_value
  }

  lifecycle {
    ignore_changes = [
      desired_count,   # updated by autoscaling
      task_definition, # updated by codedeploy
    ]
  }
}

data "template_file" "masked_metrics" {
  template = var.template_file
  vars = merge(var.vars, {
    awslogs-group = aws_cloudwatch_log_group.log.name
    name          = var.name
  })
}
