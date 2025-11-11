output "vpc_id" {
  description = "ID de la VPC principal"
  value       = aws_vpc.main.id
}

output "public_subnet_ids" {
  description = "Lista de IDs de las subredes públicas"
  value       = aws_subnet.public[*].id
}

output "private_subnet_ids" {
  description = "Lista de IDs de las subredes privadas"
  value       = aws_subnet.private[*].id
}

output "nat_gateway_eip" {
  description = "IP pública del NAT Gateway"
  value       = aws_eip.nat.public_ip
}
