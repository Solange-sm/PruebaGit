output "alb_sg_id" {
  description = "ID del Security Group para los Load Balancers"
  value       = aws_security_group.alb_sg.id
}

output "web_sg_id" {
  description = "ID del Security Group para el WebServer estático"
  value       = aws_security_group.web_sg.id
}

output "backend_sg_id" {
  description = "ID del Security Group para las instancias Backend"
  value       = aws_security_group.backend_sg.id
}

output "rds_sg_id" {
  description = "ID del Security Group para la Base de Datos RDS"
  value       = aws_security_group.rds_sg.id
}

output "eice_sg_id" {
  description = "ID del Security Group para el EC2 Instance Connect Endpoint"
  value       = aws_security_group.eice_sg.id
}