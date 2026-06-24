variable "region" {
  type        = string
  description = "AWS region."
  default     = "us-east-1"
}

variable "name" {
  type        = string
  description = "Base name."
  default     = "ecs-fargate"
}

variable "cidr_block" {
  type        = string
  description = "VPC CIDR."
  default     = "10.3.0.0/16"
}

variable "azs" {
  type        = list(string)
  description = "Availability zones."
  default     = ["us-east-1a", "us-east-1b"]
}

variable "public_subnet_cidrs" {
  type        = list(string)
  description = "Public subnet CIDRs."
  default     = ["10.3.1.0/24", "10.3.2.0/24"]
}

variable "private_subnet_cidrs" {
  type        = list(string)
  description = "Private subnet CIDRs."
  default     = ["10.3.101.0/24", "10.3.102.0/24"]
}

variable "container_image" {
  type        = string
  description = "Container image URI."
  default     = "public.ecr.aws/nginx/nginx:latest"
}

variable "container_port" {
  type        = number
  description = "Container port."
  default     = 80
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
