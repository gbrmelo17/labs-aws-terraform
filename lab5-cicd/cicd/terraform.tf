terraform {
    backend "s3" {
      bucket = "gabrielmelo-bucket"
      key = "gabriel-bucket3"
      region = "us-east-1"
    }
}