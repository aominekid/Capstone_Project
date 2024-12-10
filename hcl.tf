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

# S3-Bucket für Bilder
resource "aws_s3_bucket" "event_photos" {
  bucket = "event-photo-gallery-${var.unique_id}"
  acl    = "public-read"

  website {
    index_document = "index.html"
    error_document = "404.html"
  }

  tags = {
    Name = "EventPhotoGallery"
  }
}

# CloudFront für schnelle Verteilung
resource "aws_cloudfront_distribution" "event_photos" {
  origin {
    domain_name = aws_s3_bucket.event_photos.bucket_regional_domain_name
    origin_id   = "S3-event-photos"
  }

  enabled = true
  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "S3-event-photos"

    viewer_protocol_policy = "redirect-to-https"
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }
}
