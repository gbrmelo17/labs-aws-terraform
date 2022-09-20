terraform {
    backend "s3" {
      bucket = "gabrielmelo-bucket"
      key = "gabriel-bucket8"
      region = "us-east-1"
    }
}
