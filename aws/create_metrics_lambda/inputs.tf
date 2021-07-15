variable "service_name" {
  type        = string
  description = "Name of the service"
}

variable "dead_letter_queue_arn" {
  type = string
}

variable "metrics_key_arn" {
  type = string
}

variable "raw_metrics_arn" {
  type = string
}

variable "raw_metrics_stream_arn" {
  type = string
}

variable "metrics_execution_arn" {
  type = string
}

variable "rest_api_id" {
  type = string
}

variable "resource_id" {
  type = string
}

variable "http_method" {
  type = string
}

variable "feature_count_alarms" {
  type = bool
}

variable "create_metrics_dynamodb_wcu_max" {
  type = string
}

variable "create_metrics_max_avg_duration" {
  type = string
}
