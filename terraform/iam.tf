resource "aws_iam_role" "ec2" {
  name = "cloudticket-ec2-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Effect = "Allow"

        Principal = {
          Service = "ec2.amazonaws.com"
        }

        Action = "sts:AssumeRole"
      }
    ]
  })

  tags = {
    Name = "cloudticket-ec2-role"
  }
}

resource "aws_iam_role_policy_attachment" "ssm" {
  role       = aws_iam_role.ec2.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_role_policy_attachment" "s3_migration" {
  role       = aws_iam_role.ec2.name
  policy_arn = aws_iam_policy.s3_migration.arn
}

resource "aws_iam_instance_profile" "ec2" {
  name = "cloudticket-ec2-profile"
  role = aws_iam_role.ec2.name
}