terraform {
  backend "s3" {
    bucket       = "dev-terraform-state-s3-sebas1012"
    key          = "envs/dev/terraform.tfstate"
    region       = "us-west-2"
    encrypt      = true
    use_lockfile = true
  }
}
