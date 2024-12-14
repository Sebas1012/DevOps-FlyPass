resource "aws_s3_bucket" "s3_bucket" {
  bucket = var.s3_bucket_name
  tags = merge(var.tags, { 
    Name = var.s3_bucket_name 
    Username = var.username
  })
}

resource "aws_s3_bucket_policy" "bucket_policy" {
  bucket = aws_s3_bucket.s3_bucket.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = "*"
        Action   = "s3:PutObject"
        Resource = "${aws_s3_bucket.s3_bucket.arn}/*"
        Condition = {
          IpAddress = {
            "aws:SourceIp" = [
              var.private_subnets
            ]
          }
        }
      }
    ]
  })
}