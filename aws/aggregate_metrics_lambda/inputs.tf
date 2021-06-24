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

variable "aggregate_metrics_arn" {
  type = string
}

variable "feature_count_alarms" {
  type = bool
}

variable "aggregate_metrics_dynamodb_wcu_max" {
  type = string
}

variable "aggregate_metrics_max_avg_duration" {
  type = string
}
