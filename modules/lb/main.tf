# main.tf (Modulos/Loadbalancer)
# Contenido original de lb.tf (sin el SG)

# --- Etapa 2.2: Load Balancer 1 (Público) -> S3 (Front-End) ---
resource "aws_lb" "lb1" {
  name               = "${var.name_prefix}-lb1-frontend-${substr(md5(var.vpc_id), 0, 8)}"
  internal           = false # Público
  load_balancer_type = "application"

  # Subredes PÚBLICAS
  subnets = var.public_subnet_ids

  # SG que viene del módulo SecurityGroups
  security_groups = [var.alb_sg_id]

  tags = { Name = "${var.name_prefix}-lb1" }
}

# Target Group que solo existe para cumplir con el listener (no se usa realmente si se redirige)
resource "aws_lb_target_group" "lb1_tg_s3_redirect" {
  name        = "${var.name_prefix}-lb1-tg-s3-${substr(md5(var.vpc_id), 0, 8)}"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "ip"
}

resource "aws_lb_listener" "lb1_listener_http" {
  load_balancer_arn = aws_lb.lb1.arn
  port              = 80
  protocol          = "HTTP"

  # Redirección a S3 (Opción que seleccionaste)
  default_action {
    type = "redirect"
    redirect {
      host        = var.s3_static_site_url # URL de salida de S3
      protocol    = "HTTP"
      status_code = "HTTP_302"
    }
  }
}

# --- Etapa 2.3: Load Balancer 2 (Público) -> WebServer Estático ---
resource "aws_lb" "lb2" {
  name               = "${var.name_prefix}-lb2-webstatic-${substr(md5(var.vpc_id), 0, 8)}"
  internal           = false
  load_balancer_type = "application"

  subnets         = var.public_subnet_ids
  security_groups = [var.alb_sg_id]

  tags = { Name = "${var.name_prefix}-lb2" }
}

resource "aws_lb_target_group" "lb2_tg" {
  name        = "${var.name_prefix}-lb2-tg-${substr(md5(var.vpc_id), 0, 8)}"
  port        = 80 # El WebServer escucha en el 80
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "instance" # Apuntará a la EC2

  tags = { Name = "${var.name_prefix}-lb2-tg" }
}

resource "aws_lb_listener" "lb2_listener" {
  load_balancer_arn = aws_lb.lb2.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.lb2_tg.arn
  }
}

# --- Etapa 2.4: Load Balancer 3 (Público) -> Backend Docker ---
resource "aws_lb" "lb3" {
  name               = "${var.name_prefix}-lb3-backend-${substr(md5(var.vpc_id), 0, 8)}"
  internal           = false
  load_balancer_type = "application"

  subnets         = var.public_subnet_ids
  security_groups = [var.alb_sg_id]

  tags = { Name = "${var.name_prefix}-lb3" }
}

resource "aws_lb_target_group" "lb3_tg" {
  name = "${var.name_prefix}-lb3-tg-${substr(md5(var.vpc_id), 0, 8)}"
  # El LB apunta al puerto 8080 (donde mapeamos el docker)
  port        = var.backend_app_port
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "instance"

  health_check {
    path = var.backend_health_path
    port = "traffic-port" # Revisa el puerto 8080
  }

  tags = { Name = "${var.name_prefix}-lb3-tg" }
}

resource "aws_lb_listener" "lb3_listener" {
  load_balancer_arn = aws_lb.lb3.arn
  port              = 80 # El LB escucha en el puerto 80 (público)
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.lb3_tg.arn
  }
}