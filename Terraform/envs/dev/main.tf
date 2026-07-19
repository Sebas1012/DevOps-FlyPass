provider "aws" {
  region = var.aws_region

  default_tags {
    tags = {
      username    = var.username
      environment = var.environment
      project     = var.project
    }
  }
}

data "aws_caller_identity" "current" {}

locals {
  name_prefix      = "${var.project}-${var.environment}"
  outputs_bucket   = "${local.name_prefix}-outputs-${data.aws_caller_identity.current.account_id}"
  eks_cluster_name = "${local.name_prefix}-eks"
  ecr_repo_name    = "${local.name_prefix}-app"
  vpc_name         = "${local.name_prefix}-vpc"
}

module "vpc" {
  source = "../../modules/vpc"

  vpc_name        = local.vpc_name
  cidr_block      = var.cidr_block
  public_subnets  = var.public_subnets
  private_subnets = var.private_subnets
}

module "eks" {
  source = "../../modules/eks"

  cluster_name                 = local.eks_cluster_name
  cluster_version              = var.eks_cluster_version
  vpc_id                       = module.vpc.vpc_id
  private_subnet_ids           = module.vpc.private_subnet_ids
  endpoint_public_access       = var.eks_endpoint_public_access
  endpoint_public_access_cidrs = var.eks_endpoint_public_access_cidrs
  node_instance_types          = var.node_instance_types
  node_desired_size            = var.node_desired_size
  node_min_size                = var.node_min_size
  node_max_size                = var.node_max_size
  enable_container_insights    = var.enable_container_insights
}

module "s3" {
  source = "../../modules/s3"

  bucket_name = local.outputs_bucket
}

module "ecr" {
  source = "../../modules/ecr"

  repository_name = local.ecr_repo_name
}

module "iam" {
  source = "../../modules/iam"

  name_prefix                = local.name_prefix
  github_repository          = var.github_repository
  github_repository_with_ids = var.github_repository_with_ids
  state_bucket               = var.tf_state_bucket
  oidc_provider_arn          = module.eks.oidc_provider_arn
  oidc_provider_url          = module.eks.oidc_provider_url
  s3_bucket_arn              = module.s3.bucket_arn
  ecr_repository_arn         = module.ecr.repository_arn
  eks_cluster_arn            = module.eks.cluster_arn
  irsa_namespace             = var.irsa_namespace
  irsa_service_account       = var.irsa_service_account
}

# El pipeline de deploy necesita permisos dentro del cluster; se otorgan vía
# access entries (no aws-auth ConfigMap). ClusterAdmin porque el pipeline
# también gestiona namespaces y ServiceAccounts.
resource "aws_eks_access_entry" "gha_deploy" {
  cluster_name  = module.eks.cluster_name
  principal_arn = module.iam.gha_deploy_role_arn
}

resource "aws_eks_access_policy_association" "gha_deploy" {
  cluster_name  = module.eks.cluster_name
  principal_arn = module.iam.gha_deploy_role_arn
  policy_arn    = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"

  access_scope {
    type = "cluster"
  }

  depends_on = [aws_eks_access_entry.gha_deploy]
}
