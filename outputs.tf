
output "vpc_id" {
  description = "ID de la VPC principal"
  value       = module.network.vpc_id
}

output "public_subnet_ids" {
  description = "Lista de IDs de las subredes públicas"
  value       = module.network.public_subnet_ids
}

output "s3_bucket_name" {
  description = "Nombre del bucket S3"
  value       = module.storage.s3_bucket_name
}

output "s3_static_site_url" {
  description = "URL del endpoint del sitio web estático S3"
  value       = module.storage.s3_static_site_url
}

output "lb1_dns" {
  description = "DNS del Load Balancer 1 (redirección a S3)"
  value       = module.lb.lb1_dns
}

output "lb2_dns" {
  description = "DNS del Load Balancer 2 (hacia WebServer)"
  value       = module.lb.lb2_dns
}

output "lb3_dns" {
  description = "DNS del Load Balancer 3 (hacia Backend Docker)"
  value       = module.lb.lb3_dns
}

output "rds_endpoint" {
  description = "Endpoint de la Base de Datos"
  value       = module.database.rds_endpoint
}