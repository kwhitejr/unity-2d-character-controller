terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "us-east-1"
}

locals {
  bucket    = "unitykwhitejrcom-origin"
  html_site = "index.html"
}

data "aws_s3_bucket" "origin" {
  bucket = local.bucket
}

resource "aws_s3_object" "object" {
  bucket       = data.aws_s3_bucket.origin.bucket
  key          = "index.html"
  source       = "../../public/${local.html_site}"
  content_type = "text/html"

  # The filemd5() function is available in Terraform 0.11.12 and later
  # For Terraform 0.11.11 and earlier, use the md5() function and the file() function:
  # etag = "${md5(file(local.html_site))}"
  etag = filemd5("../../public/${local.html_site}")
}
