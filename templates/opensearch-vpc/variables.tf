variable "region" {
  type        = string
  description = "AWS region."
  default     = "us-east-1"
}

variable "name" {
  type        = string
  description = "Domain name."
  default     = "opensearch-demo"
}

variable "cidr_block" {
  type        = string
  description = "VPC CIDR."
  default     = "10.5.0.0/16"
}

variable "azs" {
  type        = list(string)
  description = "Availability zones."
  default     = ["us-east-1a", "us-east-1b"]
}

variable "private_subnet_cidrs" {
  type        = list(string)
  description = "Private subnet CIDRs."
  default     = ["10.5.101.0/24", "10.5.102.0/24"]
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
