locals {
  tags = merge({
    Project = var.project
    Environment = var.environment
    ManagedBy = "Terraform"
    Owner = var.owner
  }, var.extra)
}
