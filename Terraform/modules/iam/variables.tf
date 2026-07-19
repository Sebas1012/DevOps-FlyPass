variable "name_prefix" {
  description = "Prefijo de nombres para roles, políticas y scoping de recursos"
  type        = string
}

variable "github_repository" {
  description = "Repositorio GitHub en formato owner/repo autorizado a asumir los roles"
  type        = string
}

variable "github_repository_with_ids" {
  description = "Repositorio con IDs inmutables (owner@id/repo@id), formato del claim sub tras un rename"
  type        = string
  default     = ""
}

variable "state_bucket" {
  description = "Bucket S3 del backend remoto de Terraform"
  type        = string
}

variable "oidc_provider_arn" {
  description = "ARN del OIDC provider del cluster EKS (IRSA)"
  type        = string
}

variable "oidc_provider_url" {
  description = "Issuer del OIDC provider del cluster sin https://"
  type        = string
}

variable "s3_bucket_arn" {
  description = "ARN del bucket de salida al que sube archivos el pod"
  type        = string
}

variable "ecr_repository_arn" {
  description = "ARN del repositorio ECR"
  type        = string
}

variable "eks_cluster_arn" {
  description = "ARN del cluster EKS"
  type        = string
}

variable "irsa_namespace" {
  description = "Namespace del ServiceAccount que asume el rol IRSA"
  type        = string
}

variable "irsa_service_account" {
  description = "Nombre del ServiceAccount que asume el rol IRSA"
  type        = string
}
