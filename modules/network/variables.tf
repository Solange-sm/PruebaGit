variable "aws_region" {
  description = "Región AWS del laboratorio"
  type        = string
}

variable "azs" {
  description = "Lista de Zonas de Disponibilidad (AZs) a utilizar"
  type        = list(string)
}
variable "name_prefix" {
  description = "Prefijo de nombres para los recursos"
  type        = string
}

# ===== Red (VPC) =====
variable "vpc_cidr" {
  description = "Bloque CIDR principal de la VPC"
  type        = string
}

variable "public_subnet_cidrs" {
  description = "CIDRs para subnets públicas"
  type        = list(string)
}

variable "private_subnet_cidrs" {
  description = "CIDRs para subnets privadas"
  type        = list(string)
}
