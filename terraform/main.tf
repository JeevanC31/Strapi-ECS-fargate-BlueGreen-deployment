module "vpc" {
  source              = "./modules/vpc"
  vpc_cidr            = "10.0.0.0/16"
  public_subnet_cidrs = ["10.0.1.0/24", "10.0.2.0/24"]
  azs                 = ["us-east-1a", "us-east-1b"]
}

module "security" {
  source = "./modules/security"
  vpc_id = module.vpc.vpc_id
}

module "alb" {
  source          = "./modules/alb"
  vpc_id          = module.vpc.vpc_id
  public_subnets  = module.vpc.public_subnets
  alb_sg_id       = module.security.alb_sg_id
}

module "ecs" {
  source             = "./modules/ecs"
  public_subnets     = module.vpc.public_subnets
  ecs_sg_id          = module.security.ecs_sg_id
  blue_tg_arn        = module.alb.blue_tg.arn
  execution_role_arn = var.ecs_execution_role_arn
  container_image    = "nginx"
}

module "codedeploy" {
  source             = "./modules/codedeploy"
  cluster_name       = module.ecs.cluster_name
  service_name       = module.ecs.service_name
  blue_tg_name       = module.alb.blue_tg.name
  green_tg_name      = module.alb.green_tg.name
  listener_arn       = module.alb.listener_arn
  codedeploy_role_arn = var.codedeploy_role_arn
}

module "ecr" {
  source = "./modules/ecr"
}