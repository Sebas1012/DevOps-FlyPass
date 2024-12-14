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
  type        = map(string)
}

variable "private_subnets" {
  description = "Lista de bloques CIDR para las subnets privadas"
  type        = map(string)
}

variable "tags" {
  description = "Mapa de etiquetas para asignar a los recursos"
  type        = map(string)
}