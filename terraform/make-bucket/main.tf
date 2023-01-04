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
  sub             = "unity"
  domain_name     = "kwhitejr.com"
  sub_domain_name = "${local.sub}.${local.domain_name}"
}

data "aws_route53_zone" "main" {
  name         = local.domain_name
  private_zone = false
}
##### NOTE
# Annoyingly, these modules only created succussfully when doing the certificate alone,
# then adding in the cloudfront-s3-cdn on a second run
#####

module "acm_request_certificate" {
  source = "cloudposse/acm-request-certificate/aws"

  # Cloud Posse recommends pinning every module to a specific version
  # version = "x.x.x"
  domain_name = local.sub_domain_name
  # subject_alternative_names         = ["a.example.com", "b.example.com", "*.c.example.com"]
  process_domain_validation_options = true
  ttl                               = "300"
}

module "cdn" {
  source = "cloudposse/cloudfront-s3-cdn/aws"
  # Cloud Posse recommends pinning every module to a specific version
  # version = "x.x.x"

  name = local.sub_domain_name

  # DNS Settings
  aliases                 = [local.sub_domain_name]
  dns_alias_enabled       = true
  parent_zone_id          = data.aws_route53_zone.main.zone_id
  allow_ssl_requests_only = false

  # Caching Settings
  default_ttl = 300
  compress    = true

  # Website settings
  website_enabled             = true
  s3_website_password_enabled = true
  index_document              = "index.html"
  error_document              = "index.html"

  acm_certificate_arn = module.acm_request_certificate.arn
  depends_on          = [module.acm_request_certificate]
}
