# outputs.tf (Modulos/Database)
output "rds_endpoint" {
  description = "Endpoint de la Base de Datos RDS"
  value       = aws_db_instance.rds_mysql.address
}

output "rds_mysql_id" {
  description = "ID de la instancia RDS MySQL"
  value       = aws_db_instance.rds_mysql.id
}