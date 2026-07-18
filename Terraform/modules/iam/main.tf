data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

locals {
  account_id = data.aws_caller_identity.current.account_id
  region     = data.aws_region.current.region
}

resource "aws_iam_openid_connect_provider" "github" {
  url            = "https://token.actions.githubusercontent.com"
  client_id_list = ["sts.amazonaws.com"]
  thumbprint_list = [
    "6938fd4d98bab03faadb97b34396831e3780aea1",
    "1c58a3a8518e8759bf075b76b750d4f2df264fcd"
  ]
}

resource "aws_iam_role" "gha_terraform" {
  name = "${var.name_prefix}-gha-terraform"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Action = "sts:AssumeRoleWithWebIdentity"
      Principal = {
        Federated = aws_iam_openid_connect_provider.github.arn
      }
      Condition = {
        StringEquals = {
          "token.actions.githubusercontent.com:aud" = "sts.amazonaws.com"
        }
        StringLike = {
          "token.actions.githubusercontent.com:sub" = [
            "repo:${var.github_repository}:ref:refs/heads/*",
            "repo:${var.github_repository}:pull_request"
          ]
        }
      }
    }]
  })
}

resource "aws_iam_policy" "tf_networking" {
  name = "${var.name_prefix}-tf-networking"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Sid    = "Ec2Networking"
      Effect = "Allow"
      Action = [
        "ec2:Describe*",
        "ec2:CreateTags",
        "ec2:DeleteTags",
        "ec2:CreateVpc",
        "ec2:DeleteVpc",
        "ec2:ModifyVpcAttribute",
        "ec2:CreateSubnet",
        "ec2:DeleteSubnet",
        "ec2:ModifySubnetAttribute",
        "ec2:CreateInternetGateway",
        "ec2:DeleteInternetGateway",
        "ec2:AttachInternetGateway",
        "ec2:DetachInternetGateway",
        "ec2:AllocateAddress",
        "ec2:ReleaseAddress",
        "ec2:CreateNatGateway",
        "ec2:DeleteNatGateway",
        "ec2:CreateRouteTable",
        "ec2:DeleteRouteTable",
        "ec2:CreateRoute",
        "ec2:DeleteRoute",
        "ec2:AssociateRouteTable",
        "ec2:DisassociateRouteTable",
        "ec2:CreateVpcEndpoint",
        "ec2:DeleteVpcEndpoints",
        "ec2:ModifyVpcEndpoint",
        "ec2:CreateSecurityGroup",
        "ec2:DeleteSecurityGroup",
        "ec2:AuthorizeSecurityGroupIngress",
        "ec2:AuthorizeSecurityGroupEgress",
        "ec2:RevokeSecurityGroupIngress",
        "ec2:RevokeSecurityGroupEgress",
        "ec2:CreateLaunchTemplate",
        "ec2:DeleteLaunchTemplate",
        "ec2:CreateLaunchTemplateVersion",
        "ec2:DeleteLaunchTemplateVersions",
        "ec2:ModifyLaunchTemplate"
      ]
      Resource = "*"
      Condition = {
        StringEquals = {
          "aws:RequestedRegion" = local.region
        }
      }
    }]
  })
}

resource "aws_iam_policy" "tf_platform" {
  name = "${var.name_prefix}-tf-platform"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "EksCreate"
        Effect = "Allow"
        Action = [
          "eks:CreateCluster",
          "eks:RegisterCluster",
          "eks:DescribeAddonVersions"
        ]
        Resource = "*"
      },
      {
        Sid    = "EksManage"
        Effect = "Allow"
        Action = ["eks:*"]
        Resource = [
          "arn:aws:eks:${local.region}:${local.account_id}:cluster/${var.name_prefix}-*",
          "arn:aws:eks:${local.region}:${local.account_id}:nodegroup/${var.name_prefix}-*/*/*",
          "arn:aws:eks:${local.region}:${local.account_id}:access-entry/${var.name_prefix}-*/*/*/*/*",
          "arn:aws:eks:${local.region}:${local.account_id}:addon/${var.name_prefix}-*/*/*"
        ]
      },
      {
        Sid    = "IamRoles"
        Effect = "Allow"
        Action = [
          "iam:CreateRole",
          "iam:DeleteRole",
          "iam:GetRole",
          "iam:UpdateRole",
          "iam:TagRole",
          "iam:UntagRole",
          "iam:ListRolePolicies",
          "iam:ListAttachedRolePolicies",
          "iam:ListInstanceProfilesForRole",
          "iam:AttachRolePolicy",
          "iam:DetachRolePolicy",
          "iam:PutRolePolicy",
          "iam:DeleteRolePolicy",
          "iam:GetRolePolicy"
        ]
        Resource = "arn:aws:iam::${local.account_id}:role/${var.name_prefix}-*"
      },
      {
        Sid      = "IamPassRole"
        Effect   = "Allow"
        Action   = "iam:PassRole"
        Resource = "arn:aws:iam::${local.account_id}:role/${var.name_prefix}-*"
        Condition = {
          StringEquals = {
            "iam:PassedToService" = [
              "eks.amazonaws.com",
              "ec2.amazonaws.com"
            ]
          }
        }
      },
      {
        Sid    = "IamPolicies"
        Effect = "Allow"
        Action = [
          "iam:CreatePolicy",
          "iam:DeletePolicy",
          "iam:GetPolicy",
          "iam:GetPolicyVersion",
          "iam:ListPolicyVersions",
          "iam:CreatePolicyVersion",
          "iam:DeletePolicyVersion",
          "iam:TagPolicy",
          "iam:UntagPolicy"
        ]
        Resource = "arn:aws:iam::${local.account_id}:policy/${var.name_prefix}-*"
      },
      {
        Sid    = "IamOidcProviders"
        Effect = "Allow"
        Action = [
          "iam:CreateOpenIDConnectProvider",
          "iam:DeleteOpenIDConnectProvider",
          "iam:GetOpenIDConnectProvider",
          "iam:TagOpenIDConnectProvider",
          "iam:UntagOpenIDConnectProvider",
          "iam:UpdateOpenIDConnectProviderThumbprint",
          "iam:AddClientIDToOpenIDConnectProvider"
        ]
        Resource = "arn:aws:iam::${local.account_id}:oidc-provider/*"
      },
      {
        Sid      = "IamServiceLinkedRoles"
        Effect   = "Allow"
        Action   = "iam:CreateServiceLinkedRole"
        Resource = "arn:aws:iam::${local.account_id}:role/aws-service-role/*"
      },
      {
        Sid    = "CloudWatchLogs"
        Effect = "Allow"
        Action = [
          "logs:CreateLogGroup",
          "logs:DeleteLogGroup",
          "logs:PutRetentionPolicy",
          "logs:DescribeLogGroups",
          "logs:ListTagsForResource",
          "logs:TagResource",
          "logs:UntagResource"
        ]
        Resource = "arn:aws:logs:${local.region}:${local.account_id}:log-group:/aws/eks/*"
      }
    ]
  })
}

resource "aws_iam_policy" "tf_storage" {
  name = "${var.name_prefix}-tf-storage"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid      = "TerraformStateBucket"
        Effect   = "Allow"
        Action   = ["s3:ListBucket", "s3:GetBucketVersioning"]
        Resource = "arn:aws:s3:::${var.state_bucket}"
      },
      {
        Sid      = "TerraformStateObjects"
        Effect   = "Allow"
        Action   = ["s3:GetObject", "s3:PutObject", "s3:DeleteObject"]
        Resource = "arn:aws:s3:::${var.state_bucket}/*"
      },
      {
        Sid    = "OutputsBucketManagement"
        Effect = "Allow"
        Action = [
          "s3:CreateBucket",
          "s3:DeleteBucket",
          "s3:ListBucket",
          "s3:GetBucket*",
          "s3:PutBucketPolicy",
          "s3:DeleteBucketPolicy",
          "s3:PutBucketTagging",
          "s3:PutBucketVersioning",
          "s3:PutBucketPublicAccessBlock",
          "s3:GetEncryptionConfiguration",
          "s3:PutEncryptionConfiguration",
          "s3:GetAccelerateConfiguration",
          "s3:GetLifecycleConfiguration",
          "s3:GetReplicationConfiguration",
          "s3:GetObjectLockConfiguration"
        ]
        Resource = "arn:aws:s3:::${var.name_prefix}-*"
      },
      {
        Sid    = "OutputsBucketObjects"
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:DeleteObject",
          "s3:GetObjectTagging",
          "s3:PutObjectTagging"
        ]
        Resource = "arn:aws:s3:::${var.name_prefix}-*/*"
      },
      {
        Sid      = "EcrAuth"
        Effect   = "Allow"
        Action   = "ecr:GetAuthorizationToken"
        Resource = "*"
      },
      {
        Sid    = "EcrManage"
        Effect = "Allow"
        Action = [
          "ecr:CreateRepository",
          "ecr:DeleteRepository",
          "ecr:DescribeRepositories",
          "ecr:ListTagsForResource",
          "ecr:TagResource",
          "ecr:UntagResource",
          "ecr:PutLifecyclePolicy",
          "ecr:GetLifecyclePolicy",
          "ecr:DeleteLifecyclePolicy",
          "ecr:PutImageScanningConfiguration",
          "ecr:PutImageTagMutability"
        ]
        Resource = "arn:aws:ecr:${local.region}:${local.account_id}:repository/${var.name_prefix}-*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "gha_terraform" {
  for_each = {
    networking = aws_iam_policy.tf_networking.arn
    platform   = aws_iam_policy.tf_platform.arn
    storage    = aws_iam_policy.tf_storage.arn
  }

  role       = aws_iam_role.gha_terraform.name
  policy_arn = each.value
}

resource "aws_iam_role" "gha_deploy" {
  name = "${var.name_prefix}-gha-deploy"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Action = "sts:AssumeRoleWithWebIdentity"
      Principal = {
        Federated = aws_iam_openid_connect_provider.github.arn
      }
      Condition = {
        StringEquals = {
          "token.actions.githubusercontent.com:aud" = "sts.amazonaws.com"
          "token.actions.githubusercontent.com:sub" = [
            "repo:${var.github_repository}:ref:refs/heads/develop",
            "repo:${var.github_repository}:ref:refs/heads/main"
          ]
        }
      }
    }]
  })
}

resource "aws_iam_role_policy" "gha_deploy" {
  name = "${var.name_prefix}-gha-deploy"
  role = aws_iam_role.gha_deploy.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid      = "EcrAuth"
        Effect   = "Allow"
        Action   = "ecr:GetAuthorizationToken"
        Resource = "*"
      },
      {
        Sid    = "EcrPushPull"
        Effect = "Allow"
        Action = [
          "ecr:BatchCheckLayerAvailability",
          "ecr:CompleteLayerUpload",
          "ecr:InitiateLayerUpload",
          "ecr:PutImage",
          "ecr:UploadLayerPart",
          "ecr:BatchGetImage",
          "ecr:GetDownloadUrlForLayer",
          "ecr:DescribeImages",
          "ecr:ListImages"
        ]
        Resource = var.ecr_repository_arn
      },
      {
        Sid      = "EksDescribe"
        Effect   = "Allow"
        Action   = "eks:DescribeCluster"
        Resource = var.eks_cluster_arn
      }
    ]
  })
}

resource "aws_iam_role" "s3_uploader" {
  name = "${var.name_prefix}-s3-uploader"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Action = "sts:AssumeRoleWithWebIdentity"
      Principal = {
        Federated = var.oidc_provider_arn
      }
      Condition = {
        StringEquals = {
          "${var.oidc_provider_url}:sub" = "system:serviceaccount:${var.irsa_namespace}:${var.irsa_service_account}"
          "${var.oidc_provider_url}:aud" = "sts.amazonaws.com"
        }
      }
    }]
  })
}

resource "aws_iam_role_policy" "s3_uploader" {
  name = "${var.name_prefix}-s3-uploader"
  role = aws_iam_role.s3_uploader.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Sid      = "PutOutputs"
      Effect   = "Allow"
      Action   = "s3:PutObject"
      Resource = "${var.s3_bucket_arn}/outputs/*"
    }]
  })
}
