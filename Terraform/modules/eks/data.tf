data "terraform_remote_state" "eks" {
  backend = "s3"
  config = {
    bucket = "dev-terraform-state-s3-sebas1012"
    key    = "terraform.tfstate"
    region = "us-west-2"
  }
}