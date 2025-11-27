# Basic Example - Minimal Configuration
# This example shows the simplest way to use the Leapfrog Integration module

# IMPORTANT: Two-Step Setup Process
# 1. First, deploy this module to create the IAM role
# 2. Share the role ARN output with LeapFrog to receive your org_id and api_key
# 3. Add the credentials to your terraform.tfvars file:
#    leapfrog_org_id  = "your-org-id-from-dashboard"
#    leapfrog_api_key = "your-api-key-from-dashboard"
# 4. Run terraform apply again to complete the integration

terraform {
  required_version = ">= 1.0"
}

provider "aws" {
  region = "us-east-1" # Change to your preferred region
}

module "leapfrog_integration" {
  source = "../../" # When using from GitHub: "github.com/LeapFrog-Technologies-Inc/terraform-aws-leapfrog-integration?ref=v1.0.0"

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
