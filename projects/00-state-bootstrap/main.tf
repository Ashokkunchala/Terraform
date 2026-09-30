terraform {
  required_version = ">= 1.9.0, < 2.0.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 6.0, < 7.0"
    }
  }
}

variable "aws_region" {
  type    = string
  default = "us-east-1"
}

variable "bucket_name" {
  description = "Globally unique Terraform state bucket name."
  type        = string
}

provider "aws" {
  region = var.aws_region
}

resource "aws_s3_bucket" "state" {
  bucket = var.bucket_name
}

resource "aws_s3_bucket_versioning" "state" {
  bucket = aws_s3_bucket.state.id
  versioning_configuration { status = "Enabled" }
}

resource "aws_s3_bucket_public_access_block" "state" {
  bucket = aws_s3_bucket.state.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_server_side_encryption_configuration" "state" {
  bucket = aws_s3_bucket.state.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

output "bucket_name" { value = aws_s3_bucket.state.bucket }
output "backend_example" {
  value = <<-EOT
    terraform {
      backend "s3" {
        bucket       = "${aws_s3_bucket.state.bucket}"
        key          = "ecs-platform/dev/terraform.tfstate"
        region       = "${var.aws_region}"
        use_lockfile = true
      }
    }
  EOT
}
