
# data "template_file" "masked_metrics" {
#   template = file("task-definitions/metrics.json")
#   vars = {
#     name                  = "masked-metrics"
#     image                 = "hello-world"
#     awslogs-group         = aws_cloudwatch_log_group.masked_metrics_log.name
#     awslogs-region        = "ca-central-1"
#     awslogs-stream-prefix = "ecs-masked-metrics"

#   }
# }

# data "template_file" "unmasked_metrics" {
#   template = file("task-definitions/metrics.json")
#   vars = {
#     name                  = "unmasked-metrics"
#     image                 = "hello-world"
#     awslogs-group         = aws_cloudwatch_log_group.unmasked_metrics_log.name
#     awslogs-region        = "ca-central-1"
#     awslogs-stream-prefix = "ecs-masked-metrics"
#   }
# }
