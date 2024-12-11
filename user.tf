# IAM-Benutzer erstellen
resource "aws_iam_user" "terraform_user" {
  name = "terraform-user"
  path = "/"
}

# Zugriffs-Schlüssel (Access Keys) für den Benutzer erstellen
resource "aws_iam_access_key" "terraform_user_access_key" {
  user = aws_iam_user.terraform_user.name
}

# Managed Policy (AdministratorAccess) dem Benutzer zuweisen
resource "aws_iam_user_policy_attachment" "admin_access" {
  user       = aws_iam_user.terraform_user.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

# Optional: Benutzerdefinierte Policy hinzufügen
resource "aws_iam_user_policy" "custom_policy" {
  name   = "TerraformCustomPolicy"
  user   = aws_iam_user.terraform_user.name
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect   = "Allow",
        Action   = [
          "iam:CreateRole",
          "iam:AttachRolePolicy",
          "iam:PassRole",
          "s3:*"
        ],
        Resource = "*"
      }
    ]
  })
}
