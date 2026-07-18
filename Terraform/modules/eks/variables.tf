variable "cluster_name" {
  description = "Nombre del cluster EKS"
  type        = string
}

variable "cluster_version" {
  description = "Versión de Kubernetes del cluster"
  type        = string
}

variable "vpc_id" {
  description = "ID de la VPC donde se crea el cluster"
  type        = string
}

variable "private_subnet_ids" {
  description = "Subnets privadas para el control plane y los nodos"
  type        = list(string)
}

variable "endpoint_public_access" {
  description = "Habilita el endpoint público del API server"
  type        = bool
  default     = true
}

variable "endpoint_public_access_cidrs" {
  description = "CIDRs con acceso al endpoint público del API server"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "node_instance_types" {
  description = "Tipos de instancia del node group"
  type        = list(string)
  default     = ["t3.medium"]
}

variable "node_capacity_type" {
  description = "Tipo de capacidad del node group"
  type        = string
  default     = "ON_DEMAND"

  validation {
    condition     = contains(["ON_DEMAND", "SPOT"], var.node_capacity_type)
    error_message = "node_capacity_type debe ser ON_DEMAND o SPOT."
  }
}

variable "node_ami_type" {
  description = "Tipo de AMI de los nodos"
  type        = string
  default     = "AL2023_x86_64_STANDARD"
}

variable "node_desired_size" {
  description = "Cantidad deseada de nodos"
  type        = number
  default     = 1
}

variable "node_min_size" {
  description = "Cantidad mínima de nodos"
  type        = number
  default     = 1
}

variable "node_max_size" {
  description = "Cantidad máxima de nodos"
  type        = number
  default     = 2
}

variable "log_retention_days" {
  description = "Retención en días de los logs del control plane"
  type        = number
  default     = 30
}

variable "enable_container_insights" {
  description = "Instala el add-on amazon-cloudwatch-observability (logs de contenedores y métricas en CloudWatch)"
  type        = bool
  default     = true
}
