variable "cpu_units" {
  type = number
}

variable "memory" {
  type = number
}

variable "container_execution_role_arn" {
  type = string
}

variable "task_execution_role_arn" {
  type = string
}

variable "scheduled_task_role_arn" {
  type = string
}

variable "name" {
  type = string
}

variable "billing_tag_key" {
  type = string
}

variable "billing_tag_value" {
  type = string
}

variable "cluster_id" {
  type = string
}

variable "subnet_id" {
  type = string
}

variable "sg_id" {
  type = string
}

variable "template_file" {
  type = string
}

variable "vars" {
  type = map(any)
}

variable "event_rule_schedule_expression" {
  type = string
}

variable "log_retention_in_days" {
  type = string
}
