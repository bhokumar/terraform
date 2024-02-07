variable "client_secret" {
  type = string
  sensitive = true
  default = "*******************************"
}

variable "client_id" {
  type = string
  sensitive = true
  default = "*******************************"
}

variable "tenant_id" {
    type = string
    sensitive = true
    default = "*******************************"
}

variable "subscription_id" {
  type = string
  sensitive = true
  default = "*******************************"
}

variable "number_of_subnets" {
  type = number
  default = 2
  
}