resource "aws_eks_cluster" "eks_cluster" {
  name     = var.eks_cluster_name
  role_arn = var.eks_cluster_role_arn

  vpc_config {
    subnet_ids              = var.private_subnets_ids[*]
    endpoint_public_access  = true
    endpoint_private_access = true
  }

  tags = var.tags
}

resource "aws_eks_node_group" "eks-node-group" {
  cluster_name    = aws_eks_cluster.eks_cluster.name
  node_group_name = "eks-node-group"
  node_role_arn   = var.eks_nodes_role_arn
  subnet_ids      = var.private_subnets_ids
  timeouts {
    create = "20m"
  }
  scaling_config {
    desired_size = 1
    max_size     = 2
    min_size     = 1
  }

  instance_types = ["t3.medium"]

  tags = var.tags

  depends_on = [
    aws_eks_cluster.eks_cluster
  ]
}