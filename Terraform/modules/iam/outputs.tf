output "gha_terraform_role_arn" {
  description = "ARN del rol OIDC para pipelines de Terraform"
  value       = aws_iam_role.gha_terraform.arn
}

output "gha_deploy_role_arn" {
  description = "ARN del rol OIDC para pipelines de build/deploy"
  value       = aws_iam_role.gha_deploy.arn
}

output "s3_uploader_role_arn" {
  description = "ARN del rol IRSA que usa el pod para subir a S3"
  value       = aws_iam_role.s3_uploader.arn
}

output "github_oidc_provider_arn" {
  description = "ARN del OIDC provider de GitHub Actions"
  value       = aws_iam_openid_connect_provider.github.arn
}
