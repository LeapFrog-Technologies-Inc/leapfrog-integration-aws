data "aws_partition" "current" {}

resource "aws_iam_role" "leapfrog_integration_role" {
  name = "LeapfrogIntegrationRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = concat([
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
      ], [
      for principal_arn in local.trusted_principal_arns : {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          AWS = principal_arn
        }
      }
    ])
  })

  description = "IAM role for Leapfrog Integration service with Cost Explorer, Resource Groups Tagging API, Config permissions, and Lambda execution"

  tags = {
    Name    = "LeapfrogIntegrationRole"
    Service = "LeapfrogIntegration"
  }
}

resource "aws_iam_role_policy" "leapfrog_integration_policy" {
  name = "LeapfrogIntegrationPolicy"
  role = aws_iam_role.leapfrog_integration_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid = "CostExplorerAccess"
        Action = [
          "ce:GetCostAndUsage",
          "ce:GetDimensionValues",
          "ce:GetReservationUtilization",
          "ce:GetReservationCoverage",
          "ce:GetCostForecast",
          "ce:GetSavingsPlansUtilization",
          "ce:GetSavingsPlansCoverage"
        ]
        Effect   = "Allow"
        Resource = "*"
      },
      {
        Sid = "ResourceGroupsTaggingAccess"
        Action = [
          "tag:GetResources"
        ]
        Effect   = "Allow"
        Resource = "*"
      },
      {
        Sid = "ConfigServiceAccess"
        Action = [
          "config:ListDiscoveredResources"
        ]
        Effect   = "Allow"
        Resource = "*"
      },
      {
        Sid = "CloudTrailAccess"
        Action = [
          "cloudtrail:LookupEvents",
          "cloudtrail:DescribeTrails",
          "cloudtrail:GetTrailStatus"
        ]
        Effect   = "Allow"
        Resource = "*"
      },
      {
        Sid = "SSMParameterCRUDAllowAll"
        Action = [
          "ssm:PutParameter",
          "ssm:GetParameter",
          "ssm:GetParameters",
          "ssm:GetParametersByPath",
          "ssm:DeleteParameter"
        ]
        Effect   = "Allow"
        Resource = "*"
      },
      {
        Sid = "SSMParameterListForConsole"
        Action = [
          "ssm:DescribeParameters"
        ]
        Effect   = "Allow"
        Resource = "*"
      },
      {
        Sid    = "ProwlerSaaSScanPermissions"
        Effect = "Allow"
        Action = [
          "account:Get*",
          "appstream:Describe*",
          "appstream:List*",
          "backup:List*",
          "backup:Get*",
          "bedrock:List*",
          "bedrock:Get*",
          "cloudtrail:GetInsightSelectors",
          "codeartifact:List*",
          "codebuild:BatchGet*",
          "codebuild:ListReportGroups",
          "cognito-idp:GetUserPoolMfaConfig",
          "dlm:Get*",
          "drs:Describe*",
          "ds:Get*",
          "ds:Describe*",
          "ds:List*",
          "dynamodb:GetResourcePolicy",
          "ec2:GetEbsEncryptionByDefault",
          "ec2:GetSnapshotBlockPublicAccessState",
          "ec2:GetInstanceMetadataDefaults",
          "ecr:Describe*",
          "ecr:GetRegistryScanningConfiguration",
          "elasticfilesystem:DescribeBackupPolicy",
          "glue:GetConnections",
          "glue:GetSecurityConfiguration*",
          "glue:SearchTables",
          "glue:GetMLTransforms",
          "lambda:GetFunction*",
          "lightsail:GetRelationalDatabases",
          "logs:FilterLogEvents",
          "macie2:GetAutomatedDiscoveryConfiguration",
          "macie2:GetMacieSession",
          "s3:GetAccountPublicAccessBlock",
          "securityhub:BatchImportFindings",
          "securityhub:GetFindings",
          "servicecatalog:Describe*",
          "servicecatalog:List*",
          "shield:DescribeProtection",
          "shield:GetSubscriptionState",
          "ssm-incidents:List*",
          "ssm:GetDocument",
          "support:Describe*",
          "tag:GetTagKeys",
          "wellarchitected:List*"
        ]
        Resource = "*"
      },
      {
        Sid    = "ProwlerApiGatewayAccess"
        Effect = "Allow"
        Action = [
          "apigateway:GET"
        ]
        Resource = [
          "arn:${data.aws_partition.current.partition}:apigateway:*::/restapis/*",
          "arn:${data.aws_partition.current.partition}:apigateway:*::/apis/*"
        ]
      },
      {
        Sid    = "LambdaCloudWatchLogsAccess"
        Effect = "Allow"
        Action = [
          "logs:CreateLogStream",
          "logs:CreateLogGroup",
          "logs:PutLogEvents",
          "ssm:DescribeParameters"
        ]
        Resource = "*"
      },
      {
        Sid    = "LambdaSSMParameterReadAccess"
        Effect = "Allow"
        Action = [
          "ssm:GetParameterHistory",
          "ssm:GetParametersByPath",
          "ssm:GetParameters",
          "ssm:GetParameter"
        ]
        Resource = [
          aws_ssm_parameter.leapfrog_api_key.arn,
          aws_ssm_parameter.leapfrog_org_id.arn
        ]
      }
    ]
  })
}

