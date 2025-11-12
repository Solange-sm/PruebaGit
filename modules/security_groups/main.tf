# main.tf (Modulos/SecurityGroups)
# Consolidación de todos los SG dispersos

# --- 1. SG para TODOS los Load Balancers (alb_sg de lb.tf) ---
resource "aws_security_group" "alb_sg" {
  name        = "${var.name_prefix}-alb-sg"
  description = "Permite trafico web entrante"
  vpc_id      = var.vpc_id

  # HTTP
  ingress {
    protocol    = "tcp"
    from_port   = 80
    to_port     = 80
    cidr_blocks = ["0.0.0.0/0"]
  }

  # HTTPS
  ingress {
    protocol    = "tcp"
    from_port   = 443
    to_port     = 443
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Salida libre
  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = { Name = "${var.name_prefix}-alb-sg" }
}

# --- 2. SG para el WebServer (web_sg de compute.tf) ---
resource "aws_security_group" "web_sg" {
  name        = "${var.name_prefix}-web-sg"
  description = "Permite HTTP desde el LB2 y SSH"
  vpc_id      = var.vpc_id

  ingress {
    description     = "HTTP desde LB"
    protocol        = "tcp"
    from_port       = 80
    to_port         = 80
    security_groups = [aws_security_group.alb_sg.id]
  }

  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = { Name = "${var.name_prefix}-web-sg" }
}

# --- 3. SG para el Backend (backend_sg de compute.tf) ---
resource "aws_security_group" "backend_sg" {
  name        = "${var.name_prefix}-backend-sg"
  description = "Permite tráfico desde LB3 y SSH"
  vpc_id      = var.vpc_id

  ingress {
    description     = "Trafico de APP Docker desde LB3"
    protocol        = "tcp"
    from_port       = 8080
    to_port         = 8080
    security_groups = [aws_security_group.alb_sg.id]
  }

  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = { Name = "${var.name_prefix}-backend-sg" }
}

# --- 4. SG para la Base de Datos (rds_sg de database.tf) ---
resource "aws_security_group" "rds_sg" {
  name        = "${var.name_prefix}-rds-sg"
  description = "Permite MySQL solo desde el Backend"
  vpc_id      = var.vpc_id

  ingress {
    description = "Acceso MySQL desde Backend"
    protocol    = "tcp"
    from_port   = 3306
    to_port     = 3306
    # --- ¡SEGURIDAD CRÍTICA! --
    # Solo permite acceso desde el SG del backend
    security_groups = [aws_security_group.backend_sg.id]
  }

  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = { Name = "${var.name_prefix}-rds-sg" }
}

# --- 5. SG para el EICE (eice_sg de eice.tf) ---
resource "aws_security_group" "eice_sg" {
  name        = "${var.name_prefix}-eice-sg"
  description = "SG para el EC2 Instance Connect Endpoint"
  vpc_id      = var.vpc_id

  # El EICE no necesita INGRESS

  # EGRESS (Salida a instancias por SSH)
  egress {
    from_port = 22
    to_port   = 22
    protocol  = "tcp"
    # Permite conectarse a CUALQUIER IP dentro de tu VPC
    cidr_blocks = [var.vpc_cidr]
  }

  tags = { Name = "${var.name_prefix}-eice-sg" }
}