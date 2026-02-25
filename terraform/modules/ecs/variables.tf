variable "public_subnets" {
  type = list(string)
}

variable "ecs_sg_id" {
  type = string
}

variable "blue_tg_arn" {
  type = string
}

variable "execution_role_arn" {
  type = string
}

variable "container_image" {
  type = string
}
variable "db_host" {
  type = string
}