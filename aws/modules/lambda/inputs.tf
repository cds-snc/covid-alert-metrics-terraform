variable "name" {
  type = string
}

variable "repository_url" {
  type = string
}

variable "tag" {
  type = string
}

variable "role_arn" {
  type = string
}

variable "timeout" {
  type = string
}

variable "security_group_id" {
  type = string
}

variable "subnet_id" {
  type = string
}

variable "env_variables" {
  type = map(string)
}

variable "memory_size" {
  type = number
}