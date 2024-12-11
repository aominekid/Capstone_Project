resource "aws_s3_bucket_policy" "foto_bucket_policy" {
  bucket = aws_s3_bucket.foto_bucket.id
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Sid       = "AllowFullAccessForTerraformUser",
        Effect    = "Allow",
        Principal = {
          AWS = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:user/terraform-user"
        },
        Action    = "s3:*",
        Resource  = [
          "arn:aws:s3:::hochzeits-foto-bucket",     # Zugriff auf den Bucket
          "arn:aws:s3:::hochzeits-foto-bucket/*"   # Zugriff auf Inhalte im Bucket
        ]
      }
    ]
  })
}
