output "cluster_name" {
  description = "Nombre del cluster EKS"
  value       = aws_eks_cluster.main.name
}

output "cluster_arn" {
  description = "ARN del cluster EKS"
  value       = aws_eks_cluster.main.arn
}

output "cluster_endpoint" {
  description = "Endpoint del API server"
  value       = aws_eks_cluster.main.endpoint
}

output "oidc_provider_arn" {
  description = "ARN del OIDC provider del cluster (IRSA)"
  value       = aws_iam_openid_connect_provider.cluster.arn
}

output "oidc_provider_url" {
  description = "Issuer del OIDC provider sin el esquema https://"
  value       = replace(aws_eks_cluster.main.identity[0].oidc[0].issuer, "https://", "")
}

output "cluster_security_group_id" {
  description = "SG adicional del control plane"
  value       = aws_security_group.cluster.id
}

output "nodes_security_group_id" {
  description = "SG de los worker nodes"
  value       = aws_security_group.nodes.id
}

output "node_group_name" {
  description = "Nombre del node group"
  value       = aws_eks_node_group.main.node_group_name
}
