terraform {
    backend "s3" {
      bucket = "gabrielmelo-bucket"
      key = "gabriel-bucket"
      region = "us-east-1"
    }
}