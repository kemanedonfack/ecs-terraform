module "security_group_alb" {
  source              = "./modules/securitygroup"
  security_group_name = "alb-sg"
  inbound_port        = [80]
  vpc_id              = data.aws_vpc.infrastructure_vpc.id
}

module "security_group_ecs" {
  source              = "./modules/securitygroup"
  security_group_name = "ecs-sg"
  inbound_port        = [5000]
  vpc_id              = data.aws_vpc.infrastructure_vpc.id
}

module "ecs_alb" {
  source                = "./modules/alb"
  alb_name              = "Ecs-ALB"
  alb_sg_id             = module.security_group_alb.security_group_id
  alb_subnet_ids        = [data.aws_subnet.ecs_1_subnet.id, data.aws_subnet.ecs_2_subnet.id, ]
  targetgroup_name      = "Ecs-TG"
  vpc_id                = data.aws_vpc.infrastructure_vpc.id
  alb_internal          = false
  healthy_threshold     = 2
  unhealthy_threshold   = 5
  health_check_interval = 30
  health_check_path     = "/"
  health_check_timeout  = 10
  target_type           = "ip"
}

module "ecs" {
  source                    = "./modules/ecs"
  cluster_name              = "assiduite-cluster"
  service_name              = "assiduite-service"
  task_name                 = "assiduite-task-definition"
  ecr_repository_url        = "625243961866.dkr.ecr.eu-north-1.amazonaws.com/spring:edae0236c45f568df007b75a684774085f087afa"
  app_port                  = 5000
  desired_count             = 1
  ecs_subnets_ids           = [data.aws_subnet.ecs_1_subnet.id, data.aws_subnet.ecs_2_subnet.id]
  service_security_group_id = module.security_group_ecs.security_group_id
  alb_target_group_arn      = module.ecs_alb.alb_target_group_arn
}

