

resource "aws_ecs_cluster" "in-app-metrics" {
  name = "in-app-metrics"

  setting {
    name  = "containerInsights"
    value = "enabled"
  }

  tags = {
    (var.billing_tag_key) = var.billing_tag_value
  }
}

data "template_file" "covidshield_key_retrieval_task" {
  template = file("task-definitions/covidshield_key_retrieval.json")

  vars = {
    image                 = local.retrieval_repo
    awslogs-group         = aws_cloudwatch_log_group.covidshield.name
    awslogs-region        = var.region
    awslogs-stream-prefix = "ecs-${var.ecs_key_retrieval_name}"
    retrieve_hmac_key     = aws_secretsmanager_secret_version.key_retrieval_env_hmac_key.arn
    key_claim_token       = aws_secretsmanager_secret_version.key_submission_env_key_claim_token.arn
    ecdsa_key             = aws_secretsmanager_secret_version.key_retrieval_env_ecdsa_key.arn
    database_url          = aws_secretsmanager_secret_version.server_database_url.arn
    metric_provider       = var.metric_provider
    tracer_provider       = var.tracer_provider
    env                   = var.environment
    metrics_username      = var.metrics_username
    metrics_password      = aws_secretsmanager_secret_version.key_submission_metrics_password.arn
  }
}

resource "aws_ecs_task_definition" "masked_metrics" {
  family       = "masked_metrics"
  cpu          = var.cpu_units
  memory       = var.memory
  network_mode = "awsvpc"

  requires_compatibilities = ["FARGATE"]
  execution_role_arn       = aws_iam_role.covidshield_key_retrieval.arn
  task_role_arn            = aws_iam_role.covidshield_key_retrieval.arn
  container_definitions    = data.template_file.covidshield_key_retrieval_task.rendered

  tags = {
    (var.billing_tag_key) = var.billing_tag_value
  }
}

resource "aws_ecs_task_definition" "unmasked_metrics" {
  family       = "masked_metrics"
  cpu          = var.cpu_units
  memory       = var.memory
  network_mode = "awsvpc"

  requires_compatibilities = ["FARGATE"]
  execution_role_arn       = aws_iam_role.covidshield_key_retrieval.arn
  task_role_arn            = aws_iam_role.covidshield_key_retrieval.arn
  container_definitions    = data.template_file.covidshield_key_retrieval_task.rendered

  tags = {
    (var.billing_tag_key) = var.billing_tag_value
  }
}

resource "aws_ecs_service" "metrics-etl" {

  name             = var.ecs_key_retrieval_name
  cluster          = aws_ecs_cluster.in-app-metrics.id.id
  task_definition  = aws_ecs_task_definition.covidshield_key_retrieval.arn
  launch_type      = "FARGATE"
  platform_version = "1.4.0"
  # Enable the new ARN format to propagate tags to containers (see config/terraform/aws/README.md)
  propagate_tags = "SERVICE"

  desired_count                      = 1
  deployment_minimum_healthy_percent = 50
  deployment_maximum_percent         = 200
  health_check_grace_period_seconds  = 60

  network_configuration {
    assign_public_ip = false
    subnets          = aws_subnet.covidshield_private.*.id
    security_groups = [
      aws_security_group.covidshield_key_retrieval.id,
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