output "web_server_id" {
  description = "ID de la instancia del WebServer"
  value       = aws_instance.web_static.id
}

output "backend_instance_ids" {
  description = "Lista de IDs de las instancias Backend"
  value = aws_instance.backend_server[*].id
}

output "backend_private_ips" {
  description = "Lista de IPs privadas de las instancias Backend"
  value = aws_instance.backend_server[*].private_ip
}
