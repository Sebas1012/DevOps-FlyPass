output "vpc_id" {
  description = "ID de la VPC"
  value       = module.vpc.vpc_id
}

output "public_subnet_ids" {
  description = "Subnets públicas"
  value       = module.vpc.public_subnet_ids
}

output "private_subnet_ids" {
  description = "Subnets privadas"
  value       = module.vpc.private_subnet_ids
}

output "eks_cluster_name" {
  description = "Nombre del cluster EKS"
  value       = module.eks.cluster_name
}

output "eks_cluster_endpoint" {
  description = "Endpoint del API server de EKS"
  value       = module.eks.cluster_endpoint
}

output "eks_oidc_provider_arn" {
  description = "ARN del OIDC provider del cluster (IRSA)"
  value       = module.eks.oidc_provider_arn
}

output "outputs_bucket_name" {
  description = "Bucket S3 donde el CronJob deja los archivos"
  value       = module.s3.bucket_name
}

output "ecr_repository_url" {
  description = "URL del repositorio ECR"
  value       = module.ecr.repository_url
}

output "gha_terraform_role_arn" {
  description = "Rol que asume GitHub Actions para Terraform"
  value       = module.iam.gha_terraform_role_arn
}

output "gha_deploy_role_arn" {
  description = "Rol que asume GitHub Actions para build/deploy"
  value       = module.iam.gha_deploy_role_arn
}

output "s3_uploader_role_arn" {
  description = "Rol IRSA del ServiceAccount que sube archivos a S3"
  value       = module.iam.s3_uploader_role_arn
}
