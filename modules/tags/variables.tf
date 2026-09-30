variable "project" {
  description = "Project name."
  type        = string
}

variable "environment" {
  description = "Environment name."
  type        = string
}

variable "owner" {
  description = "Owning team or person."
  type        = string
}

variable "extra" {
  description = "Additional tags."
  type        = map(string)
  default     = {}
}
