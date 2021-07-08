variable "appstore_metrics_cpu_units" {
  description = "Number of CPU units to use for the appstore metrics task"
  type    = number
  default = 512
}

variable "appstore_metrics_memory" {
  description = "Memory to run the appstore metrics task with"
  type    = number
  default = 1024
}

variable "appstore_metrics_etl_repository_url" {
  description = "(required) url for the ECR repo holding the appstore metrics container"
  type = string
}

variable "appstore_metrics_etl_repository_arn" {
  description = "(required) arn for the ECR repo holding the appstore metrics container"
  type = string
}

variable "appstore_tag" {
  description = "(required) This is the tag of the image to deploy for appstore metrics"
  type = string
}

variable "masked_appstore_schedule_expression" {
  description = "(required) This controls how often/when the masked appstore metrics task is run"
  type = string
}

variable "unmasked_appstore_schedule_expression" {
  description = "(required) This controls how often/when the unmasked appstore metrics task is run"
  type = string
}
