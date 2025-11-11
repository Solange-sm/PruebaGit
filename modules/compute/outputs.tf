output "web_server_id" {
  description = "ID de la instancia WebServer"
  value       = aws_instance.web_server.id
}

output "backend_instance_ids" {
  value = aws_instance.backend[*].id
}

output "backend_private_ips" {
  value = aws_instance.backend[*].private_ip
}
