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

# Benutzerdefinierte Policy hinzufügen
resource "aws_iam_user_policy" "custom_policy" {
  name   = "TerraformCustomPolicy"
  user   = aws_iam_user.terraform_user.name
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect   = "Allow",
        Action   = [
          "s3:*",                  # Alle S3-Aktionen erlauben
          "iam:CreateRole",        # Erforderlich für Lambda-Rollen
          "iam:AttachRolePolicy",  # Rollen verwalten
          "iam:PassRole"           # Rollen weitergeben
        ],
        Resource = "*"
      }
    ]
  })
}
