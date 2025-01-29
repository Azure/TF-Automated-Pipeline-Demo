variable "application_name" {
  type = string
}

variable "environments" {
  type = list(string)
}

variable personal_access_token {
  type = string
}

variable "repository_template_url" {
  type = string
  default = "https://github.com/briantim16/Full-auto-pipelines"
}

variable "service_url" {
  type = string
  default = "https://dev.azure.com/briantimterrorform"
  
}

variable "default_reviewers" {
  type = list(string)
}

variable "minimum_number_of_reviewers" {
  type = number
}

variable "production_subscription_id" {
  type = string
}

variable "development_subscription_id" {
  type = string
}