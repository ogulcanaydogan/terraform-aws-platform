variable "bucket_name" {
  type        = string
  description = "Bucket name."
}

variable "enable_versioning" {
  type        = bool
  description = "Enable versioning."
  default     = true
}

variable "lifecycle_rules" {
  type = list(object({
    id                       = string
    enabled                  = bool
    expiration_days          = optional(number)
    transition_days          = optional(number)
    transition_storage_class = optional(string)
  }))
  default     = []
  description = "Lifecycle rules."
}

variable "log_bucket" {
  type        = string
  description = "Logging bucket name."
  default     = null
}

variable "log_prefix" {
  type        = string
  description = "Logging prefix."
  default     = null
}

variable "website" {
  type = object({
    index_document = string
    error_document = optional(string)
  })
  default     = null
  description = "Website configuration."
}

variable "tags" {
  type        = map(string)
  description = "Tags."
  default     = {}
}
