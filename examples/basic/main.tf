# Basic Example - Minimal Configuration
# This example shows the simplest way to use the Leapfrog Integration module

terraform {
  required_version = ">= 1.0"
}

provider "aws" {
  region = "us-east-1"  # Change to your preferred region
}

module "leapfrog_integration" {
  source = "../../"  # When using from GitHub: "github.com/LeapFrog-Technologies-Inc/leapfrog-infra//terraform-aws-leapfrog-integration?ref=v1.0.3"

  leapfrog_api_key = var.leapfrog_api_key
  leapfrog_org_id  = var.leapfrog_org_id
  trusted_principal_arns = [
    "arn:aws:iam::123456789012:root" # Replace with your AWS account ID or role ARNs that will assume the role
  ]

  # All alerts are enabled by default
  # No additional configuration needed for comprehensive monitoring
}

# Variables
variable "leapfrog_api_key" {
  description = "API Key for Leapfrog Platform"
  type        = string
  sensitive   = true
}

variable "leapfrog_org_id" {
  description = "Organization ID for Leapfrog Platform"
  type        = string
}

# Outputs
output "sns_topic_arn" {
  description = "ARN of the Leapfrog alerts SNS topic"
  value       = module.leapfrog_integration.sns_topic_arn
}

output "lambda_function_name" {
  description = "Name of the Leapfrog connector Lambda function"
  value       = module.leapfrog_integration.lambda_function_name
}
