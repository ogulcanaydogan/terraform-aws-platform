variable "name" {
  type        = string
  description = "Security group name."
}

variable "description" {
  type        = string
  description = "Security group description."
}

variable "vpc_id" {
  type        = string
  description = "VPC ID."
}

variable "ingress_rules" {
  type = list(object({
    description = optional(string)
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
  }))
  default     = []
  description = "Ingress rules."
}

variable "egress_rules" {
  type = list(object({
    description = optional(string)
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
  }))
  default = [{
    description = "All outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }]
  description = "Egress rules."
}

variable "tags" {
  type        = map(string)
  description = "Tags to apply to resources."
  default     = {}
}
