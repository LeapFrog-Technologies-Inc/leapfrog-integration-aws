resource "aws_iam_role" "leapfrog_integration_role" {
  name = "LeapfrogIntegrationRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
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
          AWS = "arn:aws:iam::600627338216:root"
        }
      },
    ]
  })

  description = "IAM role for Leapfrog Integration service with Cost Explorer, Resource Groups Tagging API, and Config permissions"

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
      }
    ]
  })
}

# Lambda Execution Role
resource "aws_iam_role" "leapfrog_connector_iam_role" {
  name = "leapfrog-connector-iam-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = ""
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_policy" "leapfrog_connector_policy" {
  name        = "LeapfrogConnectorIAMPolicy"
  description = "Policy for Leapfrog Connector Lambda function"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
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

resource "aws_iam_role_policy_attachment" "leapfrog_connector_policy_attachment" {
  role       = aws_iam_role.leapfrog_connector_iam_role.name
  policy_arn = aws_iam_policy.leapfrog_connector_policy.arn
}
