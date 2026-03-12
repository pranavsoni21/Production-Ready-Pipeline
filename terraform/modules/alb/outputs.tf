output "target_group_arn" {
  value = aws_lb_target_group.app-tg.arn
}

output "alb_url" {
  value = aws_lb.app-alb.dns_name
}