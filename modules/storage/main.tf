# Para mantener el código limpio, definimos el HTML en una variable local
locals {
  index_html_content = <<-EOF
    <html lang="es">
    <head>
    <meta charset="UTF-8">
    
    <title>Evaluacion Parcial 2</title>
    
    <link rel="stylesheet" href="style.css">
    </head>
    <body>
        <h1>¡Bienvenido a mi Sitio Estático en S3!</h1>
        <p>Etapa 2.1 completada con Terraform, de Nathaly Saavedra, Solange Milla y Marysabel Aedo.</p>
        <img src="lana.jpg" alt="Imagen de prueba" width="500">
    </body>
    </html>
    EOF
}

resource "random_id" "sufijo_bucket" {
  byte_length = 8
}

# --- 2.1.1. Crear bucket S3 ---
resource "aws_s3_bucket" "static_site" {
  # Usamos el prefijo de 'variables.tf' y el sufijo aleatorio
  bucket = "${var.name_prefix}-static-site-${random_id.sufijo_bucket.hex}"
}

# --- 2.1.3. Configurar Bucket Policy para acceso público ---
# (De tu 'storage.tf' anterior)

# 2.1.3a. Desactivar el Bloqueo de Acceso Público
resource "aws_s3_bucket_public_access_block" "static_public_block" {
  bucket = aws_s3_bucket.static_site.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

# 2.1.3b. Aplicar la política de lectura pública
resource "aws_s3_bucket_policy" "static_policy" {
  bucket = aws_s3_bucket.static_site.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "PublicReadGetObject"
        Effect = "Allow"
        # Principio de menor privilegio: acceso público (*)
        Principal = "*"
        Action    = "s3:GetObject"
        # REGLA: Acceso a TODOS los objetos dentro del bucket
        Resource = "${aws_s3_bucket.static_site.arn}/*"
      },
    ]
  })
  # Aseguramos que la política se aplique después de desactivar el bloqueo
  depends_on = [aws_s3_bucket_public_access_block.static_public_block]
}

# --- 2.1.1b. Habilitar "Static Website Hosting" ---
resource "aws_s3_bucket_website_configuration" "site_conf" {
  bucket = aws_s3_bucket.static_site.id
  index_document {
    suffix = "index.html"
  }
}

# --- 2.1.2. Subir archivos estáticos (HTML, CSS, Imagen) ---

# 1. El HTML
resource "aws_s3_object" "index" {
  bucket       = aws_s3_bucket.static_site.id
  key          = "index.html"
  content_type = "text/html"

  # Usamos el contenido de la variable local
  content = local.index_html_content

  # --- ESTA ES LA CORRECCIÓN ---
  # El etag se basa en el contenido de la variable, no en un archivo
  etag = md5(local.index_html_content)
}

# 2. El CSS
resource "aws_s3_object" "css" {
  bucket       = aws_s3_bucket.static_site.id
  key          = "style.css" # Nombre del archivo en el bucket
  content_type = "text/css"

  # "source" apunta al archivo local que debes crear
  source = "style.css"

  # "filemd5" calcula el hash del archivo local para rastrear cambios
  etag = filemd5("style.css")
}

# 3. La Imagen
resource "aws_s3_object" "image" {
  bucket       = aws_s3_bucket.static_site.id
  key          = "lana.jpg"
  content_type = "image/jpeg"
  source       = "lana.jpg"
  etag         = filemd5("lana.jpg")
}