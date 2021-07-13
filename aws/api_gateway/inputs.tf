variable "service_name" {
  type        = string
  description = "Name of the service"
}

variable "api-description" {
  type = string
}

variable "apiKeyName" {
  type        = string
  description = "API Key Name"
}

variable "api_gateway_rate" {
  type = string
}

variable "api_gateway_burst" {
  type = string
}

variable "route53_zone_name" {
  type = string
}

###
# Tags
###
variable "billing_tag_key" {
  description = "(required) the key we use to track billing"
  type        = string
}

variable "billing_tag_value" {
  description = "(required) the value we use to track billing"
  type        = string
}


