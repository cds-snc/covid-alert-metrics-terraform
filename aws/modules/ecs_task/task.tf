resource "aws_ecs_task_definition" "task_def" {
  family       = var.name
  cpu          = var.cpu_units
  memory       = var.memory
  network_mode = "awsvpc"

  requires_compatibilities = ["FARGATE"]
  execution_role_arn       = var.container_execution_role_arn
  task_role_arn            = var.task_execution_role_arn
  container_definitions    = data.template_file.masked_metrics.rendered

  volume {
    name = "docker-socket"
  }

  volume {
    name = "dev-fs"
  }

  volume {
    name = "proc-fs"
  }

  volume {
    name = "boot-fs"
  }

  volume {
    name = "lib-modules"
  }

  volume {
    name = "usr-fs"
  }

  tags = {
    (var.billing_tag_key) = var.billing_tag_value
  }
}

resource "aws_cloudwatch_log_group" "log" {
  # checkov:skip=CKV_AWS_158:Encryption using default CloudWatch service key is acceptable
  name              = "/aws/ecs/${var.name}_ecs"
  retention_in_days = var.log_retention_in_days
}

data "template_file" "masked_metrics" {
  template = var.template_file
  vars = merge(var.vars, {
    awslogs-group = aws_cloudwatch_log_group.log.name
    name          = var.name
  })
}
