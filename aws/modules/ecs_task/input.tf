variable "cpu_units" {
  type = number
}

variable "memory" {
  type = number
}

variable "role_arn" {
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

variable "subnet_id"{
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