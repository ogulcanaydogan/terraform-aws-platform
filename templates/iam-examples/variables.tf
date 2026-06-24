variable "region" {
  type        = string
  description = "AWS region."
  default     = "us-east-1"
}

variable "name" {
  type        = string
  description = "Base name."
  default     = "iam-examples"
}

variable "s3_bucket_arn" {
  type        = string
  description = "S3 bucket ARN to allow read-only access."
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
