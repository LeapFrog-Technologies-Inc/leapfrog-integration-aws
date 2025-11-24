output "sns_topic_arn" {
  description = "ARN of the Leapfrog alerts SNS topic"
  value       = aws_sns_topic.leapfrog_alerts_sns_topic.arn
}

output "sns_topic_name" {
  description = "Name of the Leapfrog alerts SNS topic"
  value       = aws_sns_topic.leapfrog_alerts_sns_topic.name
}

output "lambda_function_arn" {
  description = "ARN of the Leapfrog connector Lambda function"
  value       = aws_lambda_function.leapfrog_connector.arn
}

output "lambda_function_name" {
  description = "Name of the Leapfrog connector Lambda function"
  value       = aws_lambda_function.leapfrog_connector.function_name
}

output "leapfrog_integration_role_arn" {
  description = "ARN of the Leapfrog Integration IAM role"
  value       = aws_iam_role.leapfrog_integration_role.arn
}

output "leapfrog_integration_role_name" {
  description = "Name of the Leapfrog Integration IAM role"
  value       = aws_iam_role.leapfrog_integration_role.name
}
