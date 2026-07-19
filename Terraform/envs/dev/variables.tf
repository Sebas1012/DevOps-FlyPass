variable "aws_region" {
  description = "Región AWS donde se despliega la infraestructura"
  type        = string
  default     = "us-west-2"

  validation {
    condition     = can(regex("^[a-z]{2}-[a-z]+-\\d$", var.aws_region))
    error_message = "aws_region debe tener formato válido, p. ej. us-west-2."
  }
}

variable "environment" {
  description = "Ambiente de despliegue"
  type        = string

  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "environment debe ser dev, staging o prod."
  }
}

variable "project" {
  description = "Nombre del proyecto, usado en nombres y tags"
  type        = string

  validation {
    condition     = can(regex("^[a-z][a-z0-9-]{2,20}$", var.project))
    error_message = "project debe ser minúsculas/números/guiones, iniciar con letra, 3-21 caracteres."
  }
}

variable "username" {
  description = "Usuario responsable de los recursos, usado en tags"
  type        = string

  validation {
    condition     = length(var.username) > 0
    error_message = "username no puede estar vacío."
  }
}

variable "cidr_block" {
  description = "CIDR de la VPC, debe ser un /16"
  type        = string

  validation {
    condition     = can(cidrnetmask(var.cidr_block)) && endswith(var.cidr_block, "/16")
    error_message = "cidr_block debe ser un bloque CIDR válido con máscara /16."
  }
}

variable "public_subnets" {
  description = "Mapa AZ => CIDR para subnets públicas (ALB / NAT)"
  type        = map(string)

  validation {
    condition     = length(var.public_subnets) >= 2
    error_message = "Se requieren subnets públicas en al menos 2 AZs."
  }

  validation {
    condition     = alltrue([for az, _ in var.public_subnets : startswith(az, var.aws_region)])
    error_message = "Las AZs de public_subnets deben pertenecer a aws_region."
  }
}

variable "private_subnets" {
  description = "Mapa AZ => CIDR para subnets privadas (nodos EKS)"
  type        = map(string)

  validation {
    condition     = length(var.private_subnets) >= 2
    error_message = "Se requieren subnets privadas en al menos 2 AZs (requisito de EKS)."
  }

  validation {
    condition     = alltrue([for az, _ in var.private_subnets : startswith(az, var.aws_region)])
    error_message = "Las AZs de private_subnets deben pertenecer a aws_region."
  }
}

variable "eks_cluster_version" {
  description = "Versión de Kubernetes del cluster EKS"
  type        = string
  default     = "1.34"

  validation {
    condition     = can(regex("^1\\.\\d{2}$", var.eks_cluster_version))
    error_message = "eks_cluster_version debe tener formato 1.NN, p. ej. 1.33."
  }
}

variable "eks_endpoint_public_access" {
  description = "Habilita el endpoint público del API server (requerido si el pipeline corre fuera de la VPC)"
  type        = bool
  default     = true
}

variable "eks_endpoint_public_access_cidrs" {
  description = "CIDRs autorizados a alcanzar el endpoint público del API server"
  type        = list(string)
  default     = ["0.0.0.0/0"]

  validation {
    condition     = length(var.eks_endpoint_public_access_cidrs) > 0
    error_message = "Debe haber al menos un CIDR autorizado."
  }
}

variable "node_instance_types" {
  description = "Tipos de instancia para el node group"
  type        = list(string)
  default     = ["t3.micro"]
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

  validation {
    condition     = var.node_max_size >= var.node_min_size
    error_message = "node_max_size debe ser mayor o igual a node_min_size."
  }
}

variable "enable_container_insights" {
  description = "Instala el add-on de CloudWatch Observability (logs de contenedores y Container Insights)"
  type        = bool
  default     = true
}

variable "github_repository" {
  description = "Repositorio GitHub (owner/repo) autorizado en los roles OIDC"
  type        = string

  validation {
    condition     = can(regex("^[A-Za-z0-9_.-]+/[A-Za-z0-9_.-]+$", var.github_repository))
    error_message = "github_repository debe tener formato owner/repo."
  }
}

variable "github_repository_with_ids" {
  description = "Repositorio con IDs inmutables (owner@id/repo@id) que GitHub incluye en el claim sub tras un rename"
  type        = string
  default     = ""

  validation {
    condition     = var.github_repository_with_ids == "" || can(regex("^[A-Za-z0-9_.-]+@\\d+/[A-Za-z0-9_.-]+@\\d+$", var.github_repository_with_ids))
    error_message = "github_repository_with_ids debe tener formato owner@id/repo@id, p. ej. Sebas1012@50553819/CloudOps-FlyPass@902605232."
  }
}

variable "tf_state_bucket" {
  description = "Bucket S3 del backend remoto (para scoping del rol de Terraform)"
  type        = string
}

variable "irsa_namespace" {
  description = "Namespace de Kubernetes donde corre el CronJob"
  type        = string
  default     = "flypass"
}

variable "irsa_service_account" {
  description = "ServiceAccount que asume el rol IRSA"
  type        = string
  default     = "s3-uploader"
}
