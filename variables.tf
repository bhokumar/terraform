variable "client_secret" {
  type = string
  sensitive = true
  default = "4ET8Q~NERPzvyCTRJ9P.oadmrOoglkedbxFAlbpi"
}

variable "client_id" {
  type = string
  sensitive = true
  default = "9bde8c48-c938-419c-83d4-91c47717f0da"
}

variable "tenant_id" {
    type = string
    sensitive = true
    default = "bae675af-a0bb-48e4-8782-afcc8b754d86"
}

variable "subscription_id" {
  type = string
  sensitive = true
  default = "11a124d1-fbf2-42d5-aeb7-60ab02f75421"
}

variable "number_of_subnets" {
  type = number
  description = "value of the number of subnets"
  default = 2
  
  validation {
    condition = var.number_of_subnets < 5
    error_message = "The number of subnets must be less than 5."
  }
}

variable "number_of_machines" {
  type = number
  description = "value of the number of virtual machines"
  default = 2

  validation {
    condition = var.number_of_machines < 5
    error_message = "The number of machines must be less than 5."
  }
}