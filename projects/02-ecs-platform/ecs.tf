module "ecr" {
  source = "./modules/ecr"
  name   = "${local.name}-app"
}

module "ecs" {
  source = "./modules/ecs"

  name                  = local.name
  vpc_id                = module.vpc.vpc_id
  private_subnets       = module.vpc.private_subnet_ids
  alb_security_group_id = module.alb.security_group_id
  target_group_arn      = module.alb.target_group_arn
  container_image       = var.container_image
  container_port        = var.container_port
  desired_count         = var.desired_count
  min_capacity          = var.min_capacity
  max_capacity          = var.max_capacity
}

resource "aws_iam_role_policy" "db_secret_read" {
  name = "${local.name}-db-secret-read"
  role = module.ecs.task_role_arn

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Action = [
        "secretsmanager:DescribeSecret",
        "secretsmanager:GetSecretValue"
      ]
      Resource = aws_db_instance.this.master_user_secret[0].secret_arn
    }]
  })
}
