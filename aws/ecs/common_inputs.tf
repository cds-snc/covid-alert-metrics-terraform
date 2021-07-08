variable "sg_id" {
  description = "(required) the security group the scheduled tasks run in."
  type = string
}

variable "subnet_id" {
  description = "(required) the subnet the scheduled tasks run in."
  type = string
}

###
# Buckets
###

variable "masked_metrics_bucket" {
  description = "(required) the name of the bucket that's used to store masked metrics"
  type = string
}

variable "unmasked_metrics_bucket" {
  description = "(required) the name of the bucket that's used to store unmasked metrics"
  type = string
}

variable "unmasked_metrics_s3_arn" {
  description = "(required) the arn of the bucket that's used to store unmasked metrics"
  type = string

}

variable "masked_metrics_s3_arn" {
  description = "(required) the arn of the bucket that's used to store masked metrics"
  type = string
}


###
# Tags
###
variable "billing_tag_key" {
  description = "(required) the key we use to track billing"
  type = string
}

variable "billing_tag_value" {
  description = "(required) the value we use to track billing"
  type = string
}


