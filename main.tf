# main.tf (Raíz del proyecto)

# Definición de Zonas de Disponibilidad (usado en el módulo network)
locals {
    azs = ["us-east-1a", "us-east-1b"] 
}

# ==========================================================
# 1. MÓDULO NETWORK
# Corregido: Usa 'local.azs'
# ==========================================================
module "network" {
    source               = "./modules/network"
    
    aws_region           = var.aws_region 
    
    vpc_cidr             = var.vpc_cidr
    public_subnet_cidrs  = var.public_subnet_cidrs
    private_subnet_cidrs = var.private_subnet_cidrs
    name_prefix          = var.name_prefix
    azs                  = local.azs 
}

# ==========================================================
# 2. MÓDULO SECURITY GROUPS
# ==========================================================
module "security_groups" {
    source               = "./modules/security_groups" 
    
    vpc_id               = module.network.vpc_id 
    vpc_cidr             = var.vpc_cidr 
    name_prefix          = var.name_prefix
}

# ==========================================================
# 3. MÓDULO STORAGE
# Corregido: Eliminado 'aws_region'
# ==========================================================
module "storage" {
    source               = "./modules/storage"
    name_prefix          = var.name_prefix
    # aws_region ya no se pasa aquí
}

# ==========================================================
# 4. MÓDULO DATABASE
# Corregido: Añadido 'vpc_id'
# ==========================================================
module "database" {
    source               = "./modules/database"
    
    # CORRECCIÓN: Añadido vpc_id (necesario para el DB Subnet Group y el SG)
    vpc_id               = module.network.vpc_id 
    
    private_subnet_ids   = module.network.private_subnet_ids 
    rds_sg_id            = module.security_groups.rds_sg_id 
    
    name_prefix          = var.name_prefix
    db_username          = var.db_username
    db_password          = var.db_password
    rds_instance_class   = var.rds_instance_class
    rds_engine_version   = var.rds_engine_version
    rds_allocated_storage = var.rds_allocated_storage
    db_name              = var.db_name
}

# ==========================================================
# 5. MÓDULO LOAD BALANCER
# ==========================================================
module "lb" {
    source               = "./modules/lb" 
    
    vpc_id               = module.network.vpc_id
    public_subnet_ids    = module.network.public_subnet_ids
    alb_sg_id            = module.security_groups.alb_sg_id
    
    s3_static_site_url   = module.storage.s3_static_site_url 
    
    name_prefix          = var.name_prefix
    backend_health_path  = var.backend_health_path
    backend_app_port    = var.backend_app_port
}

# ==========================================================
# 6. MÓDULO COMPUTE
# Corregido: Las variables que daban error estaban aquí (se asume que este es el uso correcto)
# ==========================================================
module "compute" {
    source               = "./modules/compute"
    
    # --- DEPENDENCIAS DE RED ---
    public_subnet_ids    = module.network.public_subnet_ids
    private_subnet_ids   = module.network.private_subnet_ids
    
    # --- DEPENDENCIAS DE SECURITY GROUPS ---
    web_sg_id            = module.security_groups.web_sg_id
    backend_sg_id        = module.security_groups.backend_sg_id
    eice_sg_id           = module.security_groups.eice_sg_id
    
    # --- DEPENDENCIAS DE DATABASE ---
    rds_endpoint         = module.database.rds_endpoint 
    db_username          = var.db_username
    db_password          = var.db_password
    
    # --- DEPENDENCIAS DE LOAD BALANCER ---
    lb2_tg_arn           = module.loadbalancer.lb2_tg_arn
    lb3_tg_arn           = module.loadbalancer.lb3_tg_arn
    
    # --- VARIABLES SIMPLES (que causaron el error "No declaration found") ---
    name_prefix          = var.name_prefix
    key_name             = var.key_name
    web_instance_type    = var.web_instance_type # Se asume que usa esta variable
    backend_instance_type = var.backend_instance_type
    backend_count        = var.backend_count
    backend_container_image = var.backend_container_image
    backend_host_port    = var.backend_app_port
    backend_container_port = var.backend_container_port 
}