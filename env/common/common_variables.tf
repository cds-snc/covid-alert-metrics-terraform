

variable "account_id" {
  description = "(Required) The account ID to perform actions on."
  type        = string
}

variable "env" {
  description = "(Required) The current running environment"
  type        = string
}

variable "region" {
  description = "(Required) The region to build infra in"
  type        = string
}

variable "default_log_retention_in_days" {
  description = "(Required) The default cloudfront log retention period"
  type        = number
}
