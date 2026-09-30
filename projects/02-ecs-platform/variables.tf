variable "aws_region" {
  description = "AWS region."
  type        = string
  default     = "us-east-1"
}

variable "project" {
  description = "Project identifier."
  type        = string
  default     = "ecs-platform"
}

variable "environment" {
  description = "Environment name."
  type        = string
  default     = "dev"
  validation {
    condition     = contains(["dev", "stage", "prod"], var.environment)
    error_message = "environment must be dev, stage, or prod."
  }
}

variable "owner" {
  description = "Resource owner."
  type        = string
  default     = "platform-team"
}

variable "vpc_cidr" {
  description = "VPC CIDR."
  type        = string
  default     = "10.40.0.0/16"
}

variable "certificate_arn" {
  description = "Optional ACM certificate ARN. When supplied, HTTP redirects to HTTPS."
  type        = string
  default     = null
}

variable "container_image" {
  description = "Container image URI. Use an ECR URI for production; nginx is a safe default for the first deployment."
  type        = string
  default     = "public.ecr.aws/docker/library/nginx:alpine"
}

variable "container_port" {
  description = "Application container port."
  type        = number
  default     = 80
}

variable "desired_count" {
  description = "Initial ECS desired count."
  type        = number
  default     = 2
}

variable "min_capacity" {
  description = "Minimum ECS task count."
  type        = number
  default     = 2
}

variable "max_capacity" {
  description = "Maximum ECS task count."
  type        = number
  default     = 4
}

variable "single_nat_gateway" {
  description = "Use one NAT gateway to reduce lab cost. Set false for one NAT gateway per AZ."
  type        = bool
  default     = true
}

variable "db_instance_class" {
  description = "RDS instance class."
  type        = string
  default     = "db.t4g.micro"
}

variable "db_name" {
  description = "Application database name."
  type        = string
  default     = "appdb"
}

variable "db_username" {
  description = "RDS master username."
  type        = string
  default     = "appadmin"
}
