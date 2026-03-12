# Create ECS cluster
resource "aws_ecs_cluster" "app-cluster" {
  name = "app-cluster"
  setting {
    name  = "containerInsights"
    value = "enabled"
  }
}

# Create cloudwatch group
resource "aws_cloudwatch_log_group" "log_group" {
  name = "/ecs/app-service"
  retention_in_days = 7
}

data "aws_region" "current" {}

# Create ECS task definition
resource "aws_ecs_task_definition" "app-task" {
  family                = "app-task"
  requires_compatibilities = ["FARGATE"]
  network_mode = var.network_mode
  cpu = var.ecs_task_cpu
  memory = var.ecs_task_memory
  execution_role_arn = var.iam_role_arn
  depends_on = [aws_cloudwatch_log_group.log_group]
  container_definitions = jsonencode([
    {
      name      = "app-container"
      image     = "${var.ecr_repository_url}:${var.image_tag}"
      cpu       = 10
      memory    = 512
      essential = true
      portMappings = [
        {
          containerPort = var.container_port
          hostPort      = var.container_port
        }
      ]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = aws_cloudwatch_log_group.log_group.name
          awslogs-region        = data.aws_region.current.region
          awslogs-stream-prefix = "ecs"
        }
      }
    }
  ])
}

# Create ECS Service
resource "aws_ecs_service" "app-service" {
  name = "app-service"
  force_new_deployment = true
  cluster = aws_ecs_cluster.app-cluster.id
  task_definition = aws_ecs_task_definition.app-task.arn

  launch_type = "FARGATE"
  availability_zone_rebalancing = "ENABLED"
  desired_count = var.desired_count

  deployment_circuit_breaker {
    enable   = true
    rollback = true
  }

  load_balancer {
    target_group_arn = var.target_group_arn
    container_name = "app-container"
    container_port = var.container_port
  }

  network_configuration {
    security_groups = var.security_groups_id
    subnets = var.private_subnets
  }
}