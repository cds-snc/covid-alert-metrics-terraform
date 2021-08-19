# TO-DO: Reintroduce this afte the apply is complete
# variable "raw_metrics_name" {
#   type = string
# }

# variable "aggregate_metrics_name" {
#   type = string
# }

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

variable "feature_qr_code_alarms" {
  description = "Should QR code alarms be created"
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

variable "api_gateway_traffic_change_percent" {
  description = "Maximum traffic percentage change between current and previous day"
  type        = string
}

variable "app_500_qr_parse_error_critical_threshold" {
  description = "Maximum sum of QR parse errors in a 24 hour period before a critical alarm triggers"
  type        = string
}

variable "app_500_qr_parse_error_warning_threshold" {
  description = "Maximum sum of QR parse errors in a 24 hour period before a warning alarm triggers"
  type        = string
}

variable "service_name" {
  type        = string
  description = "Name of the service"
}
