resource "aws_ecs_cluster" "this" {
  name = "strapi-bluegreen-cluster-bgt10"
}

resource "aws_ecs_task_definition" "this" {
  family                   = "strapi-task"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = 512
  memory                   = 1024
  execution_role_arn       = var.execution_role_arn

  container_definitions = jsonencode([
    {
      name      = "strapi"
      image     = var.container_image
      essential = true

      portMappings = [
        {
          containerPort = 1337
          protocol      = "tcp"
        }
      ]

      environment = [
        {
          name  = "HOST"
          value = "0.0.0.0"
        },
        {
          name  = "PORT"
          value = "1337"
        },
        {
          name  = "NODE_ENV"
          value = "production"
        },
        {
          name  = "APP_KEYS"
          value = "key1,key2,key3,key4"
        },
        {
          name  = "API_TOKEN_SALT"
          value = "randomsalt123"
        },
        {
          name  = "ADMIN_JWT_SECRET"
          value = "randomadminjwt123"
        },
        {
          name  = "JWT_SECRET"
          value = "randomjwt123"
        },

        # PostgreSQL Configuration
        {
          name  = "DATABASE_CLIENT"
          value = "postgres"
        },
        {
          name  = "DATABASE_HOST"
          value = var.rds_endpoint
        },
        {
          name  = "DATABASE_PORT"
          value = "5432"
        },
        {
          name  = "DATABASE_NAME"
          value = var.db_name
        },
        {
          name  = "DATABASE_USERNAME"
          value = var.db_username
        },
        {
          name  = "DATABASE_PASSWORD"
          value = var.db_password
        },
        {
          name  = "DATABASE_SSL"
          value = "true"
        }
        {
          name="DATABASE_SSL_REJECT_UNAUTHORIZED", 
          value = "false"
        }
      ]
    }
  ])
}

resource "aws_ecs_service" "this" {
  name            = "strapi-service"
  cluster         = aws_ecs_cluster.this.id
  task_definition = aws_ecs_task_definition.this.arn
  desired_count   = 2
  launch_type     = "FARGATE"
  health_check_grace_period_seconds = 180
  
  lifecycle {
  ignore_changes = [
    task_definition,
    network_configuration,
    load_balancer,
    desired_count
  ]
}

  deployment_controller {
    type = "CODE_DEPLOY"
  }

  network_configuration {
    subnets         = var.public_subnets
    security_groups = [var.ecs_sg_id]
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = var.blue_tg_arn
    container_name   = "strapi"
    container_port   = 1337
  }
}