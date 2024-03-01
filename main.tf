module "security_group_ecs" {
  source              = "./modules/securitygroup"
  security_group_name = "ecs-sg"
  inbound_port        = []
  vpc_id              = data.aws_vpc.infrastructure_vpc.id
}

module "ecs" {
  source                    = "./modules/ecs"
  cluster_name              = "bash-cluster"
  service_name              = "bash-service"
  task_name                 = "bash-task-definition"
  ecr_repository_url        = "625243961866.dkr.ecr.eu-north-1.amazonaws.com/bash:latest"
  app_port                  = 5000
  desired_count             = 1
  ecs_subnets_ids           = [data.aws_subnet.ecs_1_subnet.id, data.aws_subnet.ecs_2_subnet.id]
  service_security_group_id = module.security_group_ecs.security_group_id
  task_policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}

