# outputs.tf (Modulos/Loadbalancer)
output "lb1_dns" {
  description = "DNS del Load Balancer 1 (redirección a S3)"
  value       = aws_lb.lb1.dns_name
}

output "lb2_dns" {
  description = "DNS del Load Balancer 2 (hacia WebServer)"
  value       = aws_lb.lb2.dns_name
}

output "lb3_dns" {
  description = "DNS del Load Balancer 3 (hacia Backend Docker)"
  value       = aws_lb.lb3.dns_name
}

output "lb2_tg_arn" {
  description = "ARN del Target Group de LB2 (para adjuntar la EC2)"
  value       = aws_lb_target_group.lb2_tg.arn
}

output "lb3_tg_arn" {
  description = "ARN del Target Group de LB3 (para adjuntar el Backend)"
  value       = aws_lb_target_group.lb3_tg.arn
}