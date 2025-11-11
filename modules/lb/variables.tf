
# variables.tf (Modulos/Loadbalancer)
variable "name_prefix" { type = string }
variable "public_subnet_ids" { type = list(string) }
variable "vpc_id" { type = string }
variable "alb_sg_id" { type = string }
variable "s3_static_site_url" { type = string }
variable "backend_health_path" { type = string }
variable "backend_app_port" { type = number }