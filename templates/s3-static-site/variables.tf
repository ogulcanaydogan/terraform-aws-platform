variable "region" {
  type        = string
  description = "AWS region for S3 and Route53."
  default     = "us-east-1"
}

variable "name" {
  type        = string
  description = "Base name."
  default     = "static-site"
}

variable "domain_name" {
  type        = string
  description = "Domain name for the site (e.g. example.com)."
}

variable "hosted_zone_id" {
  type        = string
  description = "Route53 hosted zone ID for the domain."
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
