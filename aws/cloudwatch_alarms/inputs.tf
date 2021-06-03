variable "metrics_api_gateway_name" {
  description = "Name of the metrics API gateway"
  type        = string
}

variable "sns_topic_warning_name" {
  description = "SNS topic name for warning alerts"
  type        = string
}

variable "sns_topic_critical_name" {
  description = "SNS topic name for critical alerts"
  type        = string
}

variable "feature_api_alarms" {
  description = "Should API gateway alarms be created"
  type        = bool
  default     = true
}

variable "api_gateway_400_error_threshold" {
  description = "Maximum sum of 4xx errors in a 60 second period before an alarm triggers"
  type        = string
}

variable "api_gateway_500_error_threshold" {
  description = "Maximum sum of 5xx errors in a 60 second period before an alarm triggers"
  type        = string
}

variable "api_gateway_min_invocations" {
  description = "Minimum sum of requests in a 60 second period before an alarm triggers"
  type        = string
}

variable "api_gateway_max_invocations" {
  description = "Maximum sum of requests in a 60 second period before an alarm triggers"
  type        = string
}

variable "api_gateway_max_latency" {
  description = "Maximum latency (milliseconds) in a 60 second period before an alarm triggers"
  type        = string
}