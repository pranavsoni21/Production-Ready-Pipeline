# Create a VPC
module "vpc" {
  source = "./modules/vpc"

  vpc_cidr = "10.0.0.0/16"

  public_subnets      = ["10.0.1.0/24", "10.0.2.0/24"]
  public_subnet_count = 2

  private_subnets      = ["10.0.3.0/24", "10.0.4.0/24"]
  private_subnet_count = 2

  availability_zones = ["ap-south-1a", "ap-south-1b"]
}

# Create security groups
module "security_groups" {
  source = "./modules/security-groups"

  vpc_id         = module.vpc.vpc_id
  alb_port       = 80
  container_port = 8000
}


# Create ECR Repository
module "ecr" {
  source = "./modules/ecr"
}

# Create ALB
module "alb" {
  source = "./modules/alb"

  vpc_id             = module.vpc.vpc_id
  alb_port           = 80
  target_type        = "ip"
  load_balancer_type = "application"
  security_group     = [module.security_groups.alb_sg_id]
  public_subnets     = module.vpc.public_subnets
}

# Create Iam role
module "iam_role" {
  source = "./modules/iam_role"
}

# Create ECS
module "ecs" {
  source = "./modules/ecs"

  network_mode       = "awsvpc"
  ecr_repository_url = module.ecr.ecr_repository_url
  image_tag          = "latest"
  iam_role_arn       = module.iam_role.iam_role_arm
  container_port     = 8000
  ecs_task_cpu       = 256
  ecs_task_memory    = 512
  desired_count      = 2
  target_group_arn   = module.alb.target_group_arn
  security_groups_id = [module.security_groups.container_sg_id]
  private_subnets    = module.vpc.private_subnets
}


