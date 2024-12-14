terraform {
  backend "s3" {
    bucket         = "dev-terraform-state-s3-sebas1012"
    key            = "terraform.tfstate"
    region         = "us-west-2"
    encrypt        = true
    dynamodb_table = "dev-terraform-state-lock-table-sebas1012"
  }
}