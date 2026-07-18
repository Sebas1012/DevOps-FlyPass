variable "vpc_name" {
  description = "Nombre de la VPC"
  type        = string
}

variable "cidr_block" {
  description = "Bloque CIDR de la VPC"
  type        = string
}

variable "public_subnets" {
  description = "Mapa AZ => CIDR para las subnets públicas"
  type        = map(string)
}

variable "private_subnets" {
  description = "Mapa AZ => CIDR para las subnets privadas"
  type        = map(string)
}
