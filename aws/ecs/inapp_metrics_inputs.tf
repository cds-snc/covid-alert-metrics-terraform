
variable "inapp_metrics_cpu_units" {
  description = "Number of CPU units to use for the inapp metrics task"
  type    = number
  default = 512
}

variable "inapp_metrics_memory" {
  description = "Memory to run the inapp metrics task with"
  type    = number
  default = 1024
}

variable "inapp_metrics_repository_url" {
  description = "(required) url for the ECR repo holding the inapp metrics container"
  type        = string
}

variable "inapp_metrics_repository_arn" {
  description = "(required) arn for the ECR repo holding the inapp metrics container"
  type = string
}

variable "inapp_tag" {
  description = "(required) This is the tag of the image to deploy for inapp metrics"
  type = string
}

variable "masked_inapp_schedule_expression" {
  description = "(required) This controls how often/when the masked inapp metrics task is run"
  type = string
}

variable "unmasked_inapp_schedule_expression" {
  description = "(required) This controls how often/when the unmasked inapp metrics task is run"
  type = string
}

variable "aggregate_metrics_table_arn" {
  description = "(required) The arn of the table in dynamodb to extract metrics from"
  type = string
}