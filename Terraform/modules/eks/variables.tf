variable "eks_cluster_name" {
  description = "Nombre del clúster de Kubernetes que se creará en EKS"
  type        = string
}

variable "eks_cluster_version" {
  description = "Versión de Kubernetes que se usará en el clúster de EKS"
  type        = string
  default     = "1.26"
}

variable "eks_cluster_role_arn" {
  description = "ARN para el rol del clúster de EKS"
}
variable "eks_nodes_role_arn" {
  description = "ARN para el rol de los nodos del clúster de EKS"
}

variable "tags" {
  description = "Mapa de etiquetas para asignar a los recursos"
  type        = map(string)
}

variable "private_subnets_ids" {
  type        = list(string)
  description = "IDs de las subredes privadas"
}

variable "vpc_id" {
  type        = string
  description = "ID de la VPC"
}