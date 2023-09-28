resource "aws_eks_cluster" "my_cluster" {
  name     = "my-eks-cluster"
  role_arn = aws_iam_role.my_cluster_role.arn

  vpc_config {
    subnet_ids = [aws_subnet.subnet_b.id, aws_subnet.subnet_c.id]
  }
}

resource "aws_iam_role" "my_cluster_role" {
  name = "my-eks-cluster-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "eks.amazonaws.com"
        }
      }
    ]
  })
}

data "aws_iam_policy_document" "admin_policy" {
  statement {
    actions   = ["*"]  # Replace with the specific actions you want to allow
    resources = ["*"]  # Replace with the specific resources you want to allow access to
    effect    = "Allow"
  }
}

# Attach the administrative policy to the IAM role
resource "aws_iam_policy" "admin_policy" {
  name        = "my-admin-policy"
  description = "Administrator Policy"
  
  policy = data.aws_iam_policy_document.admin_policy.json
}

resource "aws_iam_role_policy_attachment" "admin_policy_attachment" {
  policy_arn = aws_iam_policy.admin_policy.arn
  role       = aws_iam_role.my_cluster_role.name
}

resource "aws_eks_fargate_profile" "default" {
  cluster_name = aws_eks_cluster.my_cluster.name
  fargate_profile_name = "my-web-app"
  pod_execution_role_arn = aws_iam_role.fargate_execution_role.arn
  subnet_ids = [aws_subnet.subnet_b.id, aws_subnet.subnet_c.id]

  selector {
    namespace = "default"  # Replace with the namespace you want to target
  }
}

resource "aws_iam_role" "fargate_execution_role" {
  name = "my-fargate-execution-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "eks-fargate-pods.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "admin_policy_attachment2" {
  policy_arn = aws_iam_policy.admin_policy.arn
  role       = aws_iam_role.fargate_execution_role.name
}