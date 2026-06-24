variable "region" {
  type        = string
  description = "AWS region."
  default     = "us-east-1"
}

variable "name" {
  type        = string
  description = "DB identifier."
  default     = "rds-postgres"
}

variable "cidr_block" {
  type        = string
  description = "VPC CIDR."
  default     = "10.4.0.0/16"
}

variable "azs" {
  type        = list(string)
  description = "Availability zones."
  default     = ["us-east-1a", "us-east-1b"]
}

variable "private_subnet_cidrs" {
  type        = list(string)
  description = "Private subnet CIDRs."
  default     = ["10.4.101.0/24", "10.4.102.0/24"]
}

variable "db_name" {
  type        = string
  description = "Database name."
  default     = "appdb"
}

variable "db_username" {
  type        = string
  description = "Master username."
  default     = "appuser"
}

variable "db_password" {
  type        = string
  description = "Master password."
  sensitive   = true
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
