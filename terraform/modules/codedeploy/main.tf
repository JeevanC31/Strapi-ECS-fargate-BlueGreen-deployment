resource "aws_codedeploy_app" "this" {
  name             = "strapi-codedeploy-jeeva-bgt10"
  compute_platform = "ECS"
}

resource "aws_codedeploy_deployment_group" "this" {
  app_name              = aws_codedeploy_app.this.name
  deployment_group_name = "strapi-dg"
  service_role_arn      = var.codedeploy_role_arn

  deployment_config_name = "CodeDeployDefault.ECSCanary10Percent5Minutes"

  deployment_style {
    deployment_type   = "BLUE_GREEN"
    deployment_option = "WITH_TRAFFIC_CONTROL"
  }
  ecs_service {
    cluster_name = var.cluster_name
    service_name = var.service_name
  }

  load_balancer_info {
    target_group_pair_info {
      target_group {
        name = var.blue_tg_name
      }

      target_group {
        name = var.green_tg_name
      }

      prod_traffic_route {
        listener_arns = [var.listener_arn]
      }
    }
  }
  blue_green_deployment_config {

  deployment_ready_option {
    action_on_timeout = "CONTINUE_DEPLOYMENT"
  }

  terminate_blue_instances_on_deployment_success {
    action                           = "TERMINATE"
    termination_wait_time_in_minutes = 5
  }
}

  auto_rollback_configuration {
    enabled = true
    events  = ["DEPLOYMENT_FAILURE"]
  }
}