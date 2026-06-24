locals {
  tags = var.tags
}

resource "aws_s3_bucket" "logs" {
  bucket = var.log_bucket_name

  tags = merge(local.tags, {
    Name = var.log_bucket_name
  })
}

resource "aws_s3_bucket_public_access_block" "logs" {
  bucket = aws_s3_bucket.logs.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

module "bucket" {
  source            = "../../modules/s3"
  bucket_name       = var.bucket_name
  enable_versioning = true
  log_bucket        = aws_s3_bucket.logs.id
  log_prefix        = "access/"
  lifecycle_rules = [
    {
      id                       = "transition-glacier"
      enabled                  = true
      transition_days          = 30
      transition_storage_class = "GLACIER"
    },
    {
      id              = "expire-objects"
      enabled         = true
      expiration_days = 365
    }
  ]
  tags = local.tags
}
