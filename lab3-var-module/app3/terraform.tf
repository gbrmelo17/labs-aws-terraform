terraform {
    backend "s3" {
      bucket = "gabrielmelo-bucket"
      key = "gabriel-bucket4"
      region = "us-east-1"
    }
}