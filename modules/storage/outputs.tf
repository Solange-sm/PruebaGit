output "s3_bucket_name" {
  value = aws_s3_bucket.static_site.bucket
}

output "cdn_domain_name" {
  value = aws_cloudfront_distribution.cdn.domain_name
}

output "s3_static_site_url" {
  value = "http://${aws_s3_bucket_website_configuration.site_conf.website_endpoint}"
}