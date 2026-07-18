output "bucket_name" {
  description = "Nombre del bucket"
  value       = aws_s3_bucket.outputs.bucket
}

output "bucket_arn" {
  description = "ARN del bucket"
  value       = aws_s3_bucket.outputs.arn
}
