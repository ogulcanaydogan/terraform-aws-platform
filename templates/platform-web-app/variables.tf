variable "region" {
  description = "AWS region to deploy into"
  type        = string
  default     = "us-east-1"
}

variable "name" {
  description = "Base name applied to all resources in the stack"
  type        = string
  default     = "platform-web-app"
}

variable "cidr_block" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "azs" {
  description = "Availability zones for the subnets"
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b"]
}

variable "public_subnet_cidrs" {
  description = "CIDR blocks for the public subnets (ALB)"
  type        = list(string)
  default     = ["10.0.0.0/24", "10.0.1.0/24"]
}

variable "private_subnet_cidrs" {
  description = "CIDR blocks for the private subnets (ECS tasks and RDS)"
  type        = list(string)
  default     = ["10.0.10.0/24", "10.0.11.0/24"]
}

variable "container_image" {
  description = "Container image URI for the ECS service. Defaults to a public image so the stack is runnable before pushing your own to ECR."
  type        = string
  default     = "public.ecr.aws/nginx/nginx:latest"
}

variable "container_port" {
  description = "Port the container listens on"
  type        = number
  default     = 80
}

variable "desired_count" {
  description = "Number of ECS tasks to run"
  type        = number
  default     = 2
}

variable "task_cpu" {
  description = "Fargate task CPU units (256, 512, 1024, ...)"
  type        = string
  default     = "512"
}

variable "task_memory" {
  description = "Fargate task memory in MiB (512, 1024, 2048, ...)"
  type        = string
  default     = "1024"
}

variable "health_check_path" {
  description = "ALB target group health check path"
  type        = string
  default     = "/"
}

variable "db_name" {
  description = "Initial Postgres database name"
  type        = string
  default     = "appdb"
}

variable "db_username" {
  description = "Postgres master username"
  type        = string
  default     = "appuser"
}

variable "db_password" {
  description = "Postgres master password. Provide via TF_VAR_db_password or a secret store, never commit it."
  type        = string
  sensitive   = true
}

variable "db_instance_class" {
  description = "RDS instance class"
  type        = string
  default     = "db.t3.micro"
}

variable "tags" {
  description = "Tags applied to all resources"
  type        = map(string)
  default = {
    project     = "platform-web-app"
    environment = "dev"
    managed_by  = "terraform"
  }
}
