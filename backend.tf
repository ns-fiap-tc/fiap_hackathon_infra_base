terraform {
  backend "s3" {
    bucket         = "hacka-tfstate-bucket"
    key            = "infra-base/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-lock"
    encrypt        = true
  }
}
