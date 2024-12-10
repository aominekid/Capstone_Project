terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.55.0"
    }
  }
}

provider "aws" {
  region = "us-west-2"
}

# S3-Bucket erstellen
resource "aws_s3_bucket" "event_photos" {
  bucket = "event-photo-gallery-${random_string.suffix.result}"
  tags = {
    Name = "EventPhotoGallery"
  }
}

# S3-Bucket ACL (statt direkt im Bucket zu setzen)
resource "aws_s3_bucket_acl" "event_photos_acl" {
  bucket = aws_s3_bucket.event_photos.id
  acl    = "public-read"
}

# S3-Bucket Website Konfiguration
resource "aws_s3_bucket_website_configuration" "website" {
  bucket = aws_s3_bucket.event_photos.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "404.html"
  }
}

# Zufälliger String für den Bucket-Namen
resource "random_string" "suffix" {
  length  = 6
  special = false
  upper   = false
}

# Outputs
output "bucket_name" {
  value = aws_s3_bucket.event_photos.bucket
}

output "bucket_website_endpoint" {
  value = aws_s3_bucket_website_configuration.website.website_endpoint
}
