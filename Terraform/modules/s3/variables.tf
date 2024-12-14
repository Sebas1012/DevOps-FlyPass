variable "s3_bucket_name" {
  description = "Nombre del bucket S3 que se creará"
  type        = string
}

variable "private_subnets" {
  description = "Lista de bloques CIDR para las subnets privadas"
  type        = map(string)
}

variable "tags" {
  description = "Mapa de etiquetas para asignar a los recursos"
  type        = map(string)
}