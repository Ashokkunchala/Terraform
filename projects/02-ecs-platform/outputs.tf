output "load_balancer_url" {
  description = "HTTP endpoint for the application."
  value       = "http://${module.alb.load_balancer_dns_name}"
}

output "load_balancer_dns_name" {
  value = module.alb.load_balancer_dns_name
}

output "ecs_cluster_name" {
  value = module.ecs.cluster_name
}

output "ecs_service_name" {
  value = module.ecs.service_name
}

output "ecr_repository_url" {
  value = module.ecr.repository_url
}

output "rds_endpoint" {
  value = aws_db_instance.this.address
}

output "rds_secret_arn" {
  value     = aws_db_instance.this.master_user_secret[0].secret_arn
  sensitive = true
}

output "cloudwatch_log_group" {
  value = module.ecs.log_group_name
}
