variable "region" {
  type        = string
  description = "AWS region."
  default     = "us-east-1"
}

variable "bucket_name" {
  type        = string
  description = "Primary bucket name."
}

variable "log_bucket_name" {
  type        = string
  description = "Access log bucket name."
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
