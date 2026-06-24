variable "region" {
  type        = string
  description = "AWS region."
  default     = "us-east-1"
}

variable "name" {
  type        = string
  description = "Topic name."
  default     = "app-topic"
}

variable "subscriptions" {
  type = list(object({
    protocol = string
    endpoint = string
  }))
  default     = []
  description = "Subscriptions."
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
