output "blue_tg" {
  value = aws_lb_target_group.blue
}

output "green_tg" {
  value = aws_lb_target_group.green
}

output "listener_arn" {
  value = aws_lb_listener.http.arn
}
output "public_subnets" {
  value = var.public_subnets
}