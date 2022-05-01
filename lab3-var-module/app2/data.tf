data "terraform_remote_state" "vpc" {
  backend   = "s3"
  workspace = terraform.workspace
  config = {
    bucket = "gabrielmelo-bucket"
      key = "gabriel-bucket"
      region = "us-east-1"
  }
}
