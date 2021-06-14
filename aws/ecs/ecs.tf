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

module "masked_metrics" {
  source                       = "../modules/ecs_task"
  name                         = "masked_metrics"
  cpu_units                    = 1
  memory                       = 512
  task_execution_role_arn      = aws_iam_role.task_execution_role.arn
  container_execution_role_arn = aws_iam_role.container_execution_role.arn
  billing_tag_key              = var.billing_tag_key
  billing_tag_value            = var.billing_tag_value
  cluster_id                   = aws_ecs_cluster.in_app_metrics.id
  subnet_id                    = var.subnet_id
  sg_id                        = var.sg_id
  template_file                = file("task-definitions/metrics.json")
  vars = {
    image                 = "hello-world"
    awslogs-region        = "ca-central-1"
    awslogs-stream-prefix = "ecs-masked-metrics"
  }
}

module "unmasked_metrics" {
  source                       = "../modules/ecs_task"
  name                         = "unmasked_metrics"
  cpu_units                    = 1
  memory                       = 512
  container_execution_role_arn = aws_iam_role.container_execution_role.arn
  task_execution_role_arn      = aws_iam_role.task_execution_role.arn
  billing_tag_key              = var.billing_tag_key
  billing_tag_value            = var.billing_tag_value
  cluster_id                   = aws_ecs_cluster.in_app_metrics.id
  subnet_id                    = var.subnet_id
  sg_id                        = var.sg_id
  template_file                = file("task-definitions/metrics.json")
  vars = {
    image                 = "hello-world"
    awslogs-region        = "ca-central-1"
    awslogs-stream-prefix = "ecs-unmasked-metrics"
  }
}
