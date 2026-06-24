variable "region" {
  type        = string
  description = "AWS region."
  default     = "us-east-1"
}

variable "name" {
  type        = string
  description = "Base name."
  default     = "asg-alb"
}

variable "cidr_block" {
  type        = string
  description = "VPC CIDR."
  default     = "10.2.0.0/16"
}

variable "azs" {
  type        = list(string)
  description = "Availability zones."
  default     = ["us-east-1a", "us-east-1b"]
}

variable "public_subnet_cidrs" {
  type        = list(string)
  description = "Public subnet CIDRs."
  default     = ["10.2.1.0/24", "10.2.2.0/24"]
}

variable "private_subnet_cidrs" {
  type        = list(string)
  description = "Private subnet CIDRs."
  default     = ["10.2.101.0/24", "10.2.102.0/24"]
}

variable "instance_type" {
  type        = string
  description = "Instance type."
  default     = "t3.micro"
}

variable "desired_capacity" {
  type        = number
  description = "Desired capacity."
  default     = 2
}

variable "min_size" {
  type        = number
  description = "Minimum size."
  default     = 1
}

variable "max_size" {
  type        = number
  description = "Maximum size."
  default     = 3
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
