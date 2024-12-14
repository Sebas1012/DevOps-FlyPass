variable "aws_region" {
  description = "AWS region donde se desplegarán los recursos"
  type        = string
  default     = "us-east-1"
}

variable "vpc_name" {
  description = "Nombre de la VPC que se creará"
  type        = string
}

variable "cidr_block" {
  description = "Bloque CIDR para la VPC"
  type        = string
}

variable "public_subnets" {
  description = "Lista de bloques CIDR para las subnets públicas"
  type        = list(string)
}

variable "private_subnets" {
  description = "Lista de bloques CIDR para las subnets privadas"
  type        = list(string)
}

variable "eks_cluster_name" {
  description = "Nombre del clúster de Kubernetes que se creará en EKS"
  type        = string
}

variable "eks_cluster_version" {
  description = "Versión de Kubernetes que se usará en el clúster de EKS"
  type        = string
  default     = "1.26"
}

variable "s3_bucket_name" {
  description = "Nombre del bucket S3 que se creará"
  type        = string
}

variable "ecr_repo_name" {
  description = "Nombre del repositorio en ECR que se creará"
  type        = string
}

variable "tags" {
  description = "Mapa de etiquetas para asignar a los recursos"
  type        = map(string)
}