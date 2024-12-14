aws_region       = "us-west-2"
vpc_name         = "dev-flypass-test-vpc"
cidr_block       = "10.0.0.0/24"
public_subnets   = ["10.0.0.0/26"]
private_subnets  = ["10.0.0.64/26"]
eks_cluster_name = "dev-flypass-test-eks-cluster"
eks_cluster_policies = [
  "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy",
  "arn:aws:iam::aws:policy/AmazonEKSVPCResourceController"
]

eks_nodes_policies = [
  "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy",
  "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy",
  "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
]
s3_bucket_name = "dev-flypass-test-s3"
ecr_repo_name  = "dev-flypass-test-ecr"
tags = {
  "Environment" : "dev",
  "Owner" : "flypass",
  "Application" : "test",
  "Username" : "Sebastian.Henao"
}
