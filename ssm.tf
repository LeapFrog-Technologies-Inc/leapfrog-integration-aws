resource "aws_ssm_parameter" "leapfrog_api_key" {
  name        = "/leapfrog/api_key"
  description = "API Key for Leapfrog Platform"
  type        = "SecureString"
  value       = var.leapfrog_api_key
}

resource "aws_ssm_parameter" "leapfrog_org_id" {
  name        = "/leapfrog/org_id"
  description = "Organization ID for Leapfrog Platform"
  type        = "String"
  value       = var.leapfrog_org_id
}
