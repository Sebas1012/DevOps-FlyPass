output "vpc_id" {
  description = "ID de la VPC"
  value       = aws_vpc.main.id
}

output "public_subnet_ids" {
  description = "IDs de las subnets públicas"
  value       = [for s in aws_subnet.public : s.id]
}

output "private_subnet_ids" {
  description = "IDs de las subnets privadas"
  value       = [for s in aws_subnet.private : s.id]
}

output "private_route_table_id" {
  description = "ID de la route table privada"
  value       = aws_route_table.private.id
}

output "s3_vpc_endpoint_id" {
  description = "ID del VPC Endpoint Gateway hacia S3"
  value       = aws_vpc_endpoint.s3.id
}
