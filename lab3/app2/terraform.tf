terraform {
    backend "s3" {
      bucket = "gabrielmelo-bucket"
      key = "gabriel-bucket2"
      region = "us-east-1"
    }
}