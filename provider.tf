terraform {
  required_version = ">= 1.0.0"

  # --- CONFIGURACIÓN RECOMENDADA PARA LA EVALUACIÓN ---
  # Esto cumple con el indicador IE2.3.1 de la pauta.
  # Necesitas crear un bucket S3 y una tabla DynamoDB (para el bloqueo)
  # ANTES de ejecutar 'terraform init'.

  #backend "s3" {
  #bucket         = "nombre-de-tu-bucket-tfstate" # <-- CAMBIA ESTO (debe ser único globalmente)
  #key            = "evaluacion-parcial-2/terraform.tfstate"
  #region         = "us-east-1"
  #dynamodb_table = "terraform-state-lock"      # <-- CAMBIA ESTO (tabla DynamoDB)
  #encrypt        = true
  #}
}


provider "aws" {
  region = var.aws_region
}