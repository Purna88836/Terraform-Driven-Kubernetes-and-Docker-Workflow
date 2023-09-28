resource "aws_eks_cluster" "my_cluster" {
  name     = "my-eks-cluster"
  role_arn = aws_iam_role.my_cluster_role.arn

  vpc_config {
    subnet_ids = [aws_subnet.subnet_b.id]
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

resource "aws_eks_fargate_profile" "default" {
  cluster_name = aws_eks_cluster.my_cluster.name
  fargate_profile_name = "my-web-app"
  pod_execution_role_arn = aws_iam_role.fargate_execution_role.arn
  subnet_ids = [aws_subnet.subnet_b.id]

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
