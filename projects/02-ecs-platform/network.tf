module "vpc" {
  source = "./modules/vpc"

  name               = local.name
  vpc_cidr           = var.vpc_cidr
  availability_zones = slice(data.aws_availability_zones.available.names, 0, 2)
  single_nat_gateway = var.single_nat_gateway
}

module "alb" {
  source = "./modules/alb"

  name            = local.name
  vpc_id          = module.vpc.vpc_id
  public_subnets  = module.vpc.public_subnet_ids
  certificate_arn = null
  container_port  = var.container_port
}
