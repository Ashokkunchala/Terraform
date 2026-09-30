resource "aws_db_subnet_group" "this" {
  name       = "${local.name}-db"
  subnet_ids = module.vpc.private_subnet_ids
  tags       = { Name = "${local.name}-db" }
}

resource "aws_security_group" "db" {
  name        = "${local.name}-db"
  description = "Allow MySQL from ECS tasks only"
  vpc_id      = module.vpc.vpc_id

  ingress {
    description     = "MySQL from ECS"
    protocol        = "tcp"
    from_port       = 3306
    to_port         = 3306
    security_groups = [module.ecs.security_group_id]
  }

  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_db_instance" "this" {
  identifier                  = "${local.name}-mysql"
  engine                      = "mysql"
  engine_version              = "8.0"
  instance_class              = var.db_instance_class
  allocated_storage           = 20
  max_allocated_storage       = 100
  db_name                     = var.db_name
  username                    = var.db_username
  manage_master_user_password  = true
  db_subnet_group_name        = aws_db_subnet_group.this.name
  vpc_security_group_ids      = [aws_security_group.db.id]
  publicly_accessible         = false
  storage_encrypted           = true
  backup_retention_period     = var.environment == "prod" ? 7 : 1
  deletion_protection         = var.environment == "prod"
  skip_final_snapshot         = var.environment != "prod"
  apply_immediately            = var.environment != "prod"
  multi_az                    = var.environment == "prod"
  copy_tags_to_snapshot       = true
}
