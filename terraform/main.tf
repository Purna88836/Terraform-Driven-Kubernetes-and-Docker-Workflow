provider "aws" {
  region = "us-east-1"
}

resource "aws_s3_bucket" "mlops_bucket" {
  bucket = "mlops-artifacts-bucket"
  acl    = "private"
}

resource "aws_sagemaker_model" "ml_model" {
  name                  = "ml-model"
  execution_role_arn    = aws_iam_role.sagemaker_execution_role.arn
  primary_container {
    image               = "123456789012.dkr.ecr.us-east-1.amazonaws.com/ml-model:latest"
    model_data_url      = aws_s3_bucket.mlops_bucket.bucket
  }
}

resource "aws_iam_role" "sagemaker_execution_role" {
  name = "SageMakerExecutionRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "sagemaker.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy" "sagemaker_policy" {
  name = "SageMakerPolicy"
  role = aws_iam_role.sagemaker_execution_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:PutObject"
        ]
        Resource = [
          aws_s3_bucket.mlops_bucket.arn,
          "${aws_s3_bucket.mlops_bucket.arn}/*"
        ]
      }
    ]
  })
}