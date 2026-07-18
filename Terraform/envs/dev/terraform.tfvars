aws_region  = "us-west-2"
environment = "dev"
project     = "flypass-test"
username    = "sebastian-henao"

cidr_block = "10.0.0.0/16"

public_subnets = {
  "us-west-2a" = "10.0.0.0/20"
  "us-west-2b" = "10.0.16.0/20"
}

private_subnets = {
  "us-west-2a" = "10.0.32.0/19"
  "us-west-2b" = "10.0.64.0/19"
}

eks_cluster_version = "1.34"

node_instance_types = ["t3.medium"]
node_desired_size   = 1
node_min_size       = 1
node_max_size       = 2

github_repository = "Sebas1012/DevOps-FlyPass"

tf_state_bucket = "dev-terraform-state-s3-sebas1012"

irsa_namespace       = "flypass"
irsa_service_account = "s3-uploader"
