variable "dead_letter_queue_arn" {
  type = string
}

variable "dead_letter_queue_url" {
  type = string
}

variable "metrics_key_arn" {
  type = string
}

variable "raw_metrics_arn" {
  type = string
}

variable "aggregate_metrics_arn" {
  type = string
}

variable "backoff_retry_max_avg_duration" {
  type = number
}
