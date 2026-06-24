variable "region" {
  type        = string
  description = "AWS region."
  default     = "us-east-1"
}

variable "name" {
  type        = string
  description = "Queue name."
  default     = "app-queue"
}

variable "create_dlq" {
  type        = bool
  description = "Create DLQ."
  default     = true
}

variable "dlq_max_receive_count" {
  type        = number
  description = "Max receive count."
  default     = 5
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
