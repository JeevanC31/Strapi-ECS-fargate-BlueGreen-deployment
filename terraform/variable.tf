variable "region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "ecs_execution_role_arn" {
  description = "Existing ECS execution role ARN"
  type        = string
}

variable "codedeploy_role_arn" {
  description = "Existing CodeDeploy role ARN"
  type        = string
}       