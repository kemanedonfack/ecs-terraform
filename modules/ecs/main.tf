resource "aws_ecs_cluster" "ecs_cluster" {
  name = var.cluster_name
  tags = {
    Name = var.cluster_name

  }
  setting {
    name  = "containerInsights"
    value = "enabled"
  }
}

resource "aws_ecs_task_definition" "ecs_task_definition_1" {
  family                   = var.task_name
  container_definitions    = <<DEFINITION
  [
    {
      "name": "${var.task_name}",
      "image": "${var.ecr_repository_url}",
      "essential": true,
      "portMappings": [
        {
          "containerPort": ${var.app_port},
          "hostPort": ${var.app_port}
        }
      ],
      "dockerLabels": {
        "com.datadoghq.ad.instances": "[{\"host\": \"%%host%%\", \"port\": ${var.app_port}}]",
        "com.datadoghq.ad.check_names": "[\"assiduite\"]",
        "com.datadoghq.ad.init_configs": "[{}]"
      },
      "environment": []
    }
  ]
  DEFINITION
  requires_compatibilities = ["FARGATE"] # use Fargate as the launch type
  network_mode             = "awsvpc"    # add the AWS VPN network mode as this is required for Fargate
  memory                   = 2048        # Specify the memory the container requires
  cpu                      = 1024        # Specify the CPU the container requires
  execution_role_arn       = aws_iam_role.ecsTaskExecutionRole.arn
}

# resource "aws_ecs_task_definition" "ecs_task_definition_2" {
#   family                   = "datalog"
#   container_definitions    = <<DEFINITION
#   [
#     {
#       "name": "datalog",
#       "image": "datadog/agent:latest",
#       "essential": true,
#       "environment": [
#         {
#          "name": "DD_API_KEY",
#          "value": "93a87191930bff2ec8758fff1d32ff5e"
#          },
#          {
#            "name": "DD_SITE",
#            "value": "us5.datadoghq.com"
#          },
#          {
#            "name": "ECS_FARGATE",
#            "value": "true"
#          },
#          {
#            "name": "DD_APM_ENABLED",
#            "value": "true"
#          },
#          {
#            "name": "DD_APM_NON_LOCAL_TRAFFIC",
#            "value": "true"
#          },
#          {
#            "name": "DD_APM_RECEIVER_SOCKET",
#            "value": "/opt/datadog/apm/inject/run/apm.socket"
#          },
#          {
#            "name": "DD_DOGSTATSD_SOCKET",
#            "value": "/opt/datadog/apm/inject/run/dsd.socket"
#          },
#          {
#            "name": "DD_DOGSTATSD_NON_LOCAL_TRAFFIC",
#            "value": "true"
#          }
#       ]
#     }
#   ]
#   DEFINITION
#   requires_compatibilities = ["FARGATE"] # use Fargate as the launch type
#   network_mode             = "awsvpc"    # add the AWS VPN network mode as this is required for Fargate
#   memory                   = 2048        # Specify the memory the container requires
#   cpu                      = 1024        # Specify the CPU the container requires
#   execution_role_arn       = aws_iam_role.ecsTaskExecutionRole.arn
# }

resource "aws_iam_role" "ecsTaskExecutionRole" {
  name               = "ecsTaskExecutionRole"
  assume_role_policy = data.aws_iam_policy_document.assume_role_policy.json
}

data "aws_iam_policy_document" "assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

resource "aws_iam_role_policy_attachment" "ecsTaskExecutionRole_policy" {
  role       = aws_iam_role.ecsTaskExecutionRole.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_ecs_service" "ecs_service_1" {
  name            = "${var.service_name}"
  cluster         = aws_ecs_cluster.ecs_cluster.id
  task_definition = aws_ecs_task_definition.ecs_task_definition_1.arn
  desired_count   = var.desired_count
  launch_type     = "FARGATE"

  load_balancer {
    target_group_arn = var.alb_target_group_arn
    container_name   = aws_ecs_task_definition.ecs_task_definition_1.family
    container_port   = var.app_port
  }

  network_configuration {
    subnets          = var.ecs_subnets_ids
    assign_public_ip = true                                                # Provide the containers with public IPs
    security_groups  = ["${var.service_security_group_id}"] # Set up the security group
  }
}

# resource "aws_ecs_service" "ecs_service_2" {
#   name            = "data-log-service"
#   cluster         = aws_ecs_cluster.ecs_cluster.id
#   task_definition = aws_ecs_task_definition.ecs_task_definition_2.arn
#   desired_count   = var.desired_count
#   launch_type     = "FARGATE" 

#   network_configuration {
#     subnets          = var.ecs_subnets_ids
#     assign_public_ip = true                                                # Provide the containers with public IPs
#     security_groups  = ["${var.service_security_group_id}"] # Set up the security group
#   }
# }
