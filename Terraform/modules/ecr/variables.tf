variable "ecr_repo_name" {
  description = "Nombre del repositorio en ECR que se creará"
  type        = string
}

variable "tags" {
  description = "Mapa de etiquetas para asignar a los recursos"
  type        = map(string)
}