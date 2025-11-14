# main.tf (Modulos/Database)
# Contenido original de database.tf (sin el SG)

# --- Grupo de Subred para RDS ---
# (De tu 'database.tf' anterior)
# Le dice a RDS en qué subredes PRIVADAS vivir.
resource "aws_db_subnet_group" "db_group" {
  name = "${var.name_prefix}-db-subnet-group-${substr(md5(var.vpc_id), 0, 8)}"

  # Usa las subredes PRIVADAS recibidas del módulo Network
  subnet_ids = var.private_subnet_ids

  tags = { Name = "${var.name_prefix}-db-subnet-group" }

  lifecycle {
    create_before_destroy = true
  }
}

# --- Instancia RDS (Etapa 2.5) ---
# (Adaptado de tu 'database.tf' anterior)
resource "aws_db_instance" "rds_mysql" {
  # --- Identificación ---
  identifier     = "${var.name_prefix}-rds-mysql"
  engine         = "mysql"
  engine_version = var.rds_engine_version
  instance_class = var.rds_instance_class

  # --- Almacenamiento ---
  allocated_storage     = var.rds_allocated_storage
  max_allocated_storage = 100 # Límite para evitar costos
  storage_type          = "gp2"

  # --- Credenciales (¡IMPORTANTE!) ---
  db_name  = var.db_name
  username = var.db_username
  password = var.db_password # Carga la variable

  # --- Red y Seguridad ---
  db_subnet_group_name   = aws_db_subnet_group.db_group.name
  vpc_security_group_ids = [var.rds_sg_id] # REFERENCIA AL SG DEL MÓDULO SECURITYGROUP

  # --- Configuración Operacional ---
  apply_immediately   = true  # Aplica cambios de inmediato
  skip_final_snapshot = true  # Saltar snapshot final (ambiente de prueba)
  publicly_accessible = false # ¡CRÍTICO! Base de datos privada
  multi_az            = false # Por costo (ambiente de prueba)

  tags = { Name = "${var.name_prefix}-rds-mysql" }
}