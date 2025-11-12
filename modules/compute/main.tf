# main.tf (Modulos/Compute)
# Contenido original de compute.tf y eice.tf (sin los SGs)

# --- Data Source para la AMI (De tu script 'compute.tf' original) ---
data "aws_ami" "ami_linux" {
    most_recent = true
    owners      = ["amazon"]
    filter {
        name   = "name"
        values = ["amzn2-ami-hvm-*-x86_64-gp2"]
    }
}

# --- Instancia EC2 para WebServer Estático (Etapa 2.3) ---
resource "aws_instance" "web_static" {
    ami           = data.aws_ami.ami_linux.id
    instance_type = var.web_instance_type
    
    # Viven en la primera subred PÚBLICA
    subnet_id              = element(var.public_subnet_ids, 0)
    
    # Asigna el SG del WebServer
    vpc_security_group_ids = [var.web_sg_id]
    
    # Script para instalar Nginx y servir un index.html básico
    user_data = <<-EOF
        #!/bin/bash
        sudo yum update -y
        sudo amazon-linux-extras install nginx1 -y
        sudo systemctl start nginx
        sudo systemctl enable nginx
        echo "<h1>WebServer Estático (LB2) Listo</h1>" | sudo tee /usr/share/nginx/html/index.html
        EOF
        
    tags = { Name = "${var.name_prefix}-WebServer-Static" }
}

# Adjuntar la EC2 WebServer al Target Group de LB2
resource "aws_lb_target_group_attachment" "web_static_attach" {
    target_group_arn = var.lb2_tg_arn
    target_id        = aws_instance.web_static.id
    port             = 80
}

# --- 3 Instancias EC2 para el Backend (Etapa 2.4) ---
resource "aws_instance" "backend_server" {
    count         = var.backend_count # 3 instancias
    ami           = data.aws_ami.ami_linux.id
    instance_type = var.backend_instance_type
    
    # ¡IMPORTANTE! Viven en las subredes PRIVADAS
    # Usa count.index % 2 para alternar entre dos subredes privadas
    subnet_id              = element(var.private_subnet_ids, count.index % 2)
    
    # Asigna el SG del Backend
    vpc_security_group_ids = [var.backend_sg_id]
    
    # Script para instalar Docker, MariaDB y correr el contenedor
    user_data = <<-EOF
        #!/bin/bash
        sudo yum update -y
        sudo dnf install docker -y
        sudo dnf install mariadb -y
        # Iniciar y habilitar el servicio
        sudo systemctl start docker
        sudo systemctl enable docker
        
        sudo usermod -a -G docker ec2-user
        
        # Pausa de 50 seg para que Docker se inicie bien
        sleep 50 

        # Mapea el puerto del HOST (8080) al puerto del CONTENEDOR (80)
        docker run -d -p ${var.backend_host_port}:${var.backend_container_port} \
            -e DB_HOST=${var.rds_endpoint} \
            -e DB_USER=${var.db_username} \
            -e DB_PASS=${var.db_password} \
            ${var.backend_container_image}
        EOF
        
    tags = { Name = "${var.name_prefix}-Backend-${count.index + 1}" }
}

# Adjuntar las EC2 Backend al Target Group de LB3
resource "aws_lb_target_group_attachment" "backend_attach" {
    count            = var.backend_count
    target_group_arn = var.lb3_tg_arn
    target_id        = aws_instance.backend_server[count.index].id
    port             = var.backend_host_port
}

# --- Endpoint de EC2 Instance Connect (EICE) - de eice.tf ---
resource "aws_ec2_instance_connect_endpoint" "eice" {
    # Lo ponemos en la primera subred privada
    subnet_id = element(var.private_subnet_ids, 0)
    
    # Le asignamos su propio SG
    security_group_ids = [var.eice_sg_id]
    
    tags = { Name = "${var.name_prefix}-eice" }
}