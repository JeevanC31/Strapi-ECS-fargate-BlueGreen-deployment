data "aws_vpc" "default" {
  default = true
}

data "aws_subnets" "public" {
  filter {
    name   = "default-for-az"
    values = ["true"]
  }
}


module "security" {
  source = "./modules/security"
  vpc_id = data.aws_vpc.default.id
}

module "alb" {
  source         = "./modules/alb"
  vpc_id         = data.aws_vpc.default.id
  subnet_ids     = data.aws_subnets.public.ids
  alb_sg_id      = module.security.alb_sg_id
}

module "rds" {
  source      = "./modules/rds"
  vpc_id      = data.aws_vpc.default.id
  subnet_ids     = data.aws_subnets.public.ids
  ecs_sg_id   = module.security.ecs_sg_id

  db_name     = "strapidb"
  db_username = "strapi"
  db_password = "StrapiPass123"
}

module "ecs" {
  source = "./modules/ecs"

  container_image = var.container_image
  public_subnets  = module.alb.public_subnets
  ecs_sg_id       = module.security.ecs_sg_id
  blue_tg_arn     = module.alb.blue_tg.arn
  execution_role_arn = var.execution_role_arn

  rds_endpoint = module.rds.db_endpoint
  db_name      = "strapidb"
  db_username  = "strapi"
  db_password  = "StrapiPass123"
}


module "codedeploy" {
  source              = "./modules/codedeploy"
  cluster_name        = module.ecs.cluster_name
  service_name        = module.ecs.service_name
  blue_tg_name        = module.alb.blue_tg.name
  green_tg_name       = module.alb.green_tg.name
  listener_arn        = module.alb.listener_arn
  codedeploy_role_arn = var.codedeploy_role_arn
}



module "ecr" {
  source = "./modules/ecr"
}
