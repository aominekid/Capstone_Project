terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.55.0"
    }
  }
}

provider "aws" {
  region = "us-west-2" # Passe die Region an, falls nötig
}

# S3-Bucket erstellen
resource "aws_s3_bucket" "event_photos" {
  bucket = "event-photo-gallery-${random_string.suffix.result}" # Einzigartiger Name
  acl    = "public-read"

  website {
    index_document = "index.html"
    error_document = "404.html"
  }

  tags = {
    Name = "EventPhotoGallery"
  }
}

# Zufälliger String für den Bucket-Namen (damit es einzigartig ist)
resource "random_string" "suffix" {
  length  = 6
  special = false
  upper   = false
}

# Outputs, um wichtige Informationen auszugeben
output "bucket_name" {
  value = aws_s3_bucket.event_photos.bucket
}

output "bucket_website_endpoint" {
  value = aws_s3_bucket.event_photos.website_endpoint
}
