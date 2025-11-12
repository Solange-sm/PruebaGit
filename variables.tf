# ===== Configuración General =====
variable "aws_region" {
  description = "Región AWS del laboratorio"
  type        = string
  default     = "us-east-1"
}

variable "name_prefix" {
  description = "Prefijo de nombres para los recursos"
  type        = string
  default     = "nsmasm"
}

# ===== Red (VPC) =====
variable "vpc_cidr" {
  description = "Bloque CIDR principal de la VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidrs" {
  description = "CIDRs para subnets públicas"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.3.0/24"]
}

variable "private_subnet_cidrs" {
  description = "CIDRs para subnets privadas"
  type        = list(string)
  default     = ["10.0.2.0/24", "10.0.4.0/24"]
}

# ===== WebServer Estático (Etapa 2.3) =====
variable "key_name" {
  description = "Nombre del par de claves EC2 (Key Pair) existente (opcional)"
  type        = string
  default     = null
}

variable "ssh_allowed_cidr" {
  description = "Tu dirección IP pública para permitir SSH (ej: '190.10.10.1/32')"
  type        = string
  default     = "0.0.0.0/0"
}

variable "web_instance_type" {
  description = "Tipo de instancia EC2 para WebServer"
  type        = string
  default     = "t2.micro"
}

variable "web_server_content" {
  description = "Contenido HTML para el WebServer"
  type        = string
  default     = "¡Bienvenido al WebServer Estatico (Etapa 2.3)!"
}

# ===== Backend Docker (Etapa 2.4) =====
variable "backend_count" {
  description = "Cantidad de instancias backend"
  type        = number
  default     = 3
}

variable "backend_ami" {
  description = "AMI para instancias backend (Amazon Linux 2)"
  type        = string
  # Esta AMI es de us-east-1 (Amazon Linux 2)
  default = "ami-0a3c3a20c09d6f377"
}

variable "backend_instance_type" {
  description = "Tipo de instancia EC2 para backend"
  type        = string
  default     = "t2.micro"
}

variable "backend_container_image" {
  description = "Imagen de contenedor backend"
  type        = string
  # Usamos una imagen de demo que expone el puerto 80
  default = "nginxdemos/hello"
}

variable "backend_container_port" {
  description = "Puerto que expone la aplicación DENTRO del contenedor"
  type        = number
  # La imagen 'nginxdemos/hello' usa el puerto 80
  default = 80
}

variable "backend_app_port" {
  description = "Puerto en el host (EC2) que se expone al LB"
  type        = number
  # El LB se conectará a este puerto
  default = 8080
}


variable "backend_health_path" {
  description = "Ruta de health check del backend"
  type        = string
  default     = "/"
}

# ===== Base de datos RDS (Etapa 2.5) =====
variable "rds_allocated_storage" {
  description = "Almacenamiento en GB para RDS"
  type        = number
  default     = 20
}

variable "rds_engine_version" {
  description = "Versión de MySQL"
  type        = string
  default     = "8.0"
}

variable "rds_instance_class" {
  description = "Clase de instancia RDS"
  type        = string
  default     = "db.t3.micro" # Pequeña para la evaluación
}

variable "db_name" {
  description = "Nombre de la base de datos inicial"
  type        = string
  default     = "evaluaciondb"
}

variable "db_username" {
  description = "Usuario administrador de la BD"
  type        = string
  default     = "admin"
}

variable "db_password" {
  description = "Contraseña para la base de datos RDS"
  type        = string
  sensitive   = true
}
