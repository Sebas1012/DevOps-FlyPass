terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  required_version = ">= 1.0.0"
}

provider "aws" {
  region = var.aws_region
}

module "iam" {
  source        = "./modules/iam"
  eks_cluster_policies = var.eks_cluster_policies
  eks_nodes_policies  = var.eks_nodes_policies
  tags          = var.tags
}

module "vpc" {
  source          = "./modules/vpc"
  vpc_name        = var.vpc_name
  cidr_block      = var.cidr_block
  public_subnets  = var.public_subnets
  private_subnets = var.private_subnets
  tags            = var.tags
}

module "eks" {
  source               = "./modules/eks"
  depends_on           = [module.vpc]
  eks_cluster_name     = var.eks_cluster_name
  eks_cluster_version  = var.eks_cluster_version
  eks_cluster_role_arn = module.iam.eks_cluster_role_arn
  eks_nodes_role_arn   = module.iam.eks_nodes_role_arn
  vpc_id               = module.vpc.vpc_id
  private_subnets_ids  = module.vpc.private_subnets
  tags                 = var.tags

}

module "s3" {
  source          = "./modules/s3"
  s3_bucket_name  = var.s3_bucket_name
  tags            = var.tags
  private_subnets = var.private_subnets
}

module "ecr" {
  source        = "./modules/ecr"
  ecr_repo_name = var.ecr_repo_name
  tags          = var.tags
}