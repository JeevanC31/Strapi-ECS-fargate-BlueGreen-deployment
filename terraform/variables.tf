variable "region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}
variable "container_image" {
  type = string
}

variable "execution_role_arn" {
  type = string
}

variable "codedeploy_role_arn" {
  type = string
}