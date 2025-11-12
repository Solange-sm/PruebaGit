output "s3_bucket_name" {
  description = "Nombre del bucket S3"
  value       = aws_s3_bucket.static_site.bucket
}

output "s3_static_site_url" {
  description = "URL del endpoint del sitio web estático S3"
  value       = aws_s3_bucket_website_configuration.site_conf.website_endpoint
}
