variable "region" {
  type        = string
  description = "AWS region."
  default     = "us-east-1"
}

variable "name" {
  type        = string
  description = "Base name."
  default     = "log-metric"
}

variable "filter_pattern" {
  type        = string
  description = "Metric filter pattern."
  default     = "ERROR"
}

variable "alarm_email" {
  type        = string
  description = "Email address for alarm notifications."
}

variable "tags" {
  type        = map(string)
  description = "Tags."
  default = {
    project     = "terraform-templates"
    environment = "dev"
    owner       = "example"
  }
}
