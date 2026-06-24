variable "region" {
  type        = string
  description = "AWS region."
  default     = "us-east-1"
}

variable "name" {
  type        = string
  description = "Base name for resources."
  default     = "ec2-docker"
}

variable "allowed_ingress_cidrs" {
  type        = list(string)
  description = "CIDR blocks allowed to access the instance."
  default     = ["0.0.0.0/0"]
}

variable "instance_type" {
  type        = string
  description = "EC2 instance type."
  default     = "t3.micro"
}

variable "tags" {
  type        = map(string)
  description = "Tags to apply to resources."
  default = {
    project     = "terraform-templates"
    environment = "dev"
    owner       = "example"
  }
}
