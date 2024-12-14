resource "aws_iam_role" "cluster_iam_role" {
  name = "cluster-role"

  assume_role_policy = jsonencode({
    Version   = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "eks.amazonaws.com"
      }
    }]
  })

  tags = var.tags
}

resource "aws_iam_role" "nodes_iam_role" {
  name = "nodes-role"

  assume_role_policy = jsonencode({
    Version   = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
    }]
  })

  tags = var.tags
}

resource "aws_iam_role_policy_attachment" "cluster_iam_policy" {
  for_each   = toset(var.eks_cluster_policies)

  policy_arn = each.value
  role       = aws_iam_role.cluster_iam_role.name
  depends_on = [aws_iam_role.cluster_iam_role]
}

resource "aws_iam_role_policy_attachment" "nodes_iam_policy" {
  for_each   = toset(var.eks_nodes_policies)

  policy_arn = each.value
  role       = aws_iam_role.nodes_iam_role.name

  depends_on = [aws_iam_role.nodes_iam_role]
}
