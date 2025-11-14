  # variables.tf (Modulos/Compute)
variable "name_prefix" { type = string }
variable "key_name" {
  description = "Nombre del Key Pair para SSH (opcional)"
  type        = string
  default     = null
}
variable "web_instance_type" { type = string }
variable "backend_instance_type" { type = string }
variable "private_subnet_ids" { type = list(string) }
variable "public_subnet_ids" { type = list(string) }
variable "web_sg_id" { type = string }
variable "backend_sg_id" { type = string }
variable "eice_sg_id" { type = string }
variable "lb2_tg_arn" { type = string }
variable "lb3_tg_arn" { type = string }
variable "rds_endpoint" { type = string }
variable "db_username" { type = string }
variable "db_password" { type = string }
variable "backend_count" { type = number }
variable "backend_container_image" { type = string }
variable "backend_host_port" { type = number }
variable "backend_container_port" { type = number }