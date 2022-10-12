resource "aws_iam_policy" "read-only-secret" {
  name        = "allow-read-only-secret"
  path        = "/"
  description = "allow-read-only-secret"

  policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
      {
        "Sid": "VisualEditor0",
        "Effect": "Allow",
        "Action": [
          "secretsmanager:GetResourcePolicy",
          "secretsmanager:GetSecretValue",
          "secretsmanager:DescribeSecret",
          "secretsmanager:ListSecretVersionIds"
        ],
        "Resource": "arn:aws:secretsmanager:us-east-1:041583668323:secret:roboshop/all-mAn3kY"
      },
      {
        "Sid": "VisualEditor1",
        "Effect": "Allow",
        "Action": [
          "secretsmanager:GetRandomPassword",
          "secretsmanager:ListSecrets"
        ],
        "Resource": "*"
      }
    ]
  })
}

resource "aws_iam_role" "role-for-access-secrets" {
  name = "role-for-access-secrets"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })

  tags = {
    tag-key = "${local.TAG_PREFIX}-secrets-read-only"
  }
}

resource "aws_iam_role_policy_attachment" "attach-policy" {
  role       = aws_iam_role.role-for-access-secrets.name
  policy_arn = aws_iam_policy.read-only-secret.arn
}

resource "aws_iam_instance_profile" "secrets" {
  name = "Roboshop-Rabbitmq-Secretmanager-readaccess-${var.ENV}"
  role = aws_iam_role.role-for-access-secrets.name
}