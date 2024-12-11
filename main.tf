# Provider konfigurieren
provider "aws" {
  region = "eu-central-1" # Region Frankfurt
}

# S3-Bucket
resource "aws_s3_bucket" "foto_bucket" {
  bucket = "hochzeits-foto-bucket-unique-eu" # Einzigartiger Bucket-Name
  acl    = "public-read"
}

# ACL separat definieren
resource "aws_s3_bucket_acl" "foto_bucket_acl" {
  bucket = aws_s3_bucket.foto_bucket.id
}

# Versionierung separat konfigurieren
resource "aws_s3_bucket_versioning" "foto_bucket_versioning" {
  bucket = aws_s3_bucket.foto_bucket.id

  versioning_configuration {
    status = "Enabled"
  }
}

# Lambda-Funktion erstellen
resource "aws_lambda_function" "upload_lambda" {
  function_name = "FotoUploadFunction"
  role          = aws_iam_role.lambda_exec.arn
  handler       = "lambda_function.lambda_handler"
  runtime       = "python3.9"

  # Code für Lambda
  filename         = "backend/lambda_function.zip"
  source_code_hash = filebase64sha256("backend/lambda_function.zip")
  environment {
    variables = {
      BUCKET_NAME = aws_s3_bucket.foto_bucket.id
    }
  }
}

# IAM-Rolle für Lambda
resource "aws_iam_role" "lambda_exec" {
  name = "lambda_exec_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action    = "sts:AssumeRole",
        Effect    = "Allow",
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })
}

# Berechtigungen für Lambda
resource "aws_iam_role_policy" "lambda_policy" {
  name   = "lambda_policy"
  role   = aws_iam_role.lambda_exec.id
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect   = "Allow",
        Action   = [
          "s3:PutObject",
          "s3:GetObject",
          "s3:GetBucketObjectLockConfiguration" # Berechtigung hinzugefügt
        ],
        Resource = [
          "arn:aws:s3:::hochzeits-foto-bucket-unique-eu",
          "arn:aws:s3:::hochzeits-foto-bucket-unique-eu/*"
        ]
      }
    ]
  })
}

