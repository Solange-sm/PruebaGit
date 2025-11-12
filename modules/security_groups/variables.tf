# variables.tf (Modulos/SecurityGroups)
variable "name_prefix" {
  description = "Prefijo para nombrar todos los recursos"
  type        = string
}

variable "vpc_id" {
  description = "ID de la VPC principal"
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR Block de la VPC para reglas de seguridad amplias"
  type        = string
}

variable "backend_app_port" {
  description = "Puerto de la aplicación Backend"
  type        = number
}