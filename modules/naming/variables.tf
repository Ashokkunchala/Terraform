variable "project" {
  description = "Short project identifier."
  type = string
  validation {
    condition = can(regex("^[a-z0-9-]{2,30}$", var.project))
    error_message = "project must contain 2-30 lowercase letters, digits, or hyphens."
  }
}

variable "environment" {
  description = "Environment name."
  type = string
  validation {
    condition = contains(["dev", "stage", "prod", "lab"], var.environment)
    error_message = "environment must be one of: dev, stage, prod, lab."
  }
}
