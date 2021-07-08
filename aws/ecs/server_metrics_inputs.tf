
variable "server_metrics_cpu_units" {
  description = "Number of CPU units to use for the server metrics task"
  type    = number
  default = 512
}

variable "server_metrics_memory" {
  description = "Memory to run the server metrics task with"
  type    = number
  default = 1024
}

variable "server_metrics_etl_repository_url" {
  description = "(required) url for the ECR repo holding the server metrics container"
  type = string
}

variable "server_metrics_etl_repository_arn" {
  description = "(required) arn for the ECR repo holding the server metrics container"
  type = string
}

variable "server_tag" {
  description = "(required) This is the tag of the image to deploy for server metrics"
  type = string
}

variable "masked_server_schedule_expression" {
  description = "(required) This controls how often/when the masked server metrics task is run"
  type = string
}

variable "unmasked_server_schedule_expression" {
  description = "(required) This controls how often/when the unmasked server metrics task is run"
  type = string
}

variable "metrics_token" {
  description = "(required) This is the token used to authorize requests against the server metrics /events endpoint"
  type = string
}

variable "server_events_endpoint" {
  description = "(required) This is the endpoint we will be getting server metrics from"
  type = string
}