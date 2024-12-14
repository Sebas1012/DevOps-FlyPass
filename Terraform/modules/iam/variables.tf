variable "tags" {
  description = "Mapa de etiquetas para asignar a los recursos"
  type        = map(string)
}

variable "eks_cluster_policies" {
  description = "Lista de arn de políticas para el clúster de EKS"
  type        = list(string)
}

variable "eks_nodes_policies" {
  description = "Lista de arn de políticas para los nodos del clúster de EKS"
  type        = list(string)
}