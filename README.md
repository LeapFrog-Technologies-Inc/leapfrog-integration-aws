# Leapfrog Integration Module

Terraform module for integrating AWS infrastructure monitoring with the Leapfrog Platform. This module automatically captures and forwards AWS service events, alerts, and failures to your Leapfrog dashboard for centralized monitoring and observability.

## Features

- 🔔 **Comprehensive AWS Service Coverage** - Monitors 30+ AWS services including Lambda, RDS, DMS, Redshift, EC2, ECS, EMR, and more
- 🔐 **Secure Credential Management** - API keys and organization IDs stored securely in AWS SSM Parameter Store
- ⚡ **Real-time Event Processing** - Lambda-based event processing with SNS topic integration
- 🎛️ **Granular Control** - Enable/disable specific alert types via feature flags
- 🏗️ **Infrastructure as Code** - Fully declarative Terraform configuration
- 📊 **Integration Role** - Includes IAM role for Leapfrog Integration service access

## Architecture

```
AWS Services → CloudWatch Events/Alarms → SNS Topic → Lambda Function → Leapfrog Platform
                                                              ↓
                                                    SSM Parameter Store
                                                    (API Key & Org ID)
```

## Prerequisites

- Terraform >= 1.0
- AWS Account with appropriate permissions
- Leapfrog Platform account with API credentials

## Quick Start

```hcl
module "leapfrog_integration" {
  source = "./modules/leapfrog-integration"

  leapfrog_api_key = var.leapfrog_api_key  # Store in terraform.tfvars or use secrets management
  leapfrog_org_id  = var.leapfrog_org_id

  # Optional: Customize which alerts to enable (all default to true)
  enable_lambda_failure_alerts = true
  enable_rds_failure_warning_alerts = true
  enable_ec2_instance_termination_alerts = true
}
```

## Input Variables

### Required Variables

| Name | Description | Type | Example |
|------|-------------|------|---------|
| `leapfrog_api_key` | API Key for Leapfrog Platform authentication | `string` (sensitive) | `"lf_api_xxxxxxxxxxxxx"` |
| `leapfrog_org_id` | Organization ID for Leapfrog Platform | `string` | `"org_xxxxxxxxxxxxx"` |

### Optional Variables

All alert types are **enabled by default** for comprehensive monitoring. Set to `false` to disable specific alerts:

#### Compute & Container Services
- `enable_lambda_failure_alerts` - AWS Lambda function failures
- `enable_ec2_instance_termination_alerts` - EC2 instance terminations
- `enable_ec2_spot_instance_error_alerts` - EC2 Spot instance interruptions
- `enable_ec2_auto_scaling_failure_alerts` - Auto Scaling group failures
- `enable_ecs_instance_termination_alerts` - ECS container instance terminations
- `enable_ecs_task_termination_alerts` - ECS task terminations
- `enable_batch_failure_alerts` - AWS Batch job failures

#### Database Services
- `enable_rds_failure_warning_alerts` - RDS instance/cluster failures
- `enable_dms_failure_warning_alerts` - Database Migration Service failures
- `enable_redshift_error_alerts` - Redshift cluster errors

#### Data & Analytics
- `enable_emr_failure_alerts` - EMR cluster/step failures
- `enable_emr_error_alerts` - EMR configuration errors
- `enable_glue_failure_alerts` - Glue job/crawler failures
- `enable_iot_analytics_failure_alerts` - IoT Analytics dataset delivery failures

#### CI/CD & Deployment
- `enable_code_build_failure_alerts` - CodeBuild build failures
- `enable_code_deploy_failure_alerts` - CodeDeploy deployment failures
- `enable_code_pipeline_failure_alerts` - CodePipeline execution failures

#### Operations & Management
- `enable_ssm_maintainance_window_failure_alerts` - SSM Maintenance Window failures
- `enable_ssmec2_failure_alerts` - SSM State Manager/Run Command failures
- `enable_ssm_compliance_warning_alerts` - SSM Compliance warnings
- `enable_ops_works_failure_alerts` - OpsWorks deployment failures
- `enable_ops_works_error_alerts` - OpsWorks alerts

#### Storage & Backup
- `enable_ebs_failure_alerts` - EBS snapshot/volume failures
- `enable_data_sync_error_warning_alerts` - DataSync task errors
- `enable_data_lifecycle_manager_error_alerts` - DLM policy errors

#### Security & Compliance
- `enable_config_failure_alerts` - AWS Config snapshot delivery failures
- `enable_kms_key_expiration_warning_alerts` - KMS key material expiration
- `enable_macie_warning_alerts` - Macie security alerts

#### Media Services
- `enable_elemental_media_package_error_alerts` - MediaPackage errors
- `enable_elemental_media_live_error_alerts` - MediaLive channel alerts
- `enable_elemental_media_convert_error_alerts` - MediaConvert job errors

#### Machine Learning
- `enable_sagemaker_training_failure_alerts` - SageMaker training job failures
- `enable_sagemaker_transform_failure_alerts` - SageMaker transform job failures
- `enable_sagemaker_hyperparameter_failure_alerts` - SageMaker hyperparameter tuning failures

#### Other Services
- `enable_step_functions_failure_alerts` - Step Functions execution failures
- `enable_transcribe_failure_alerts` - Transcribe job failures
- `enable_signer_failure_alerts` - Code Signing job failures
- `enable_game_lift_failure_alerts` - GameLift matchmaking failures
- `enable_sms_failure_alerts` - Server Migration Service failures
- `enable_health_error_alerts` - AWS Health service issues
- `enable_trusted_advisor_error_warning_alerts` - Trusted Advisor recommendations

#### Lambda Monitoring
- `lambda_function_names` - Specific Lambda functions to monitor (defaults to all functions except leapfrog-connector)

## Outputs

The module creates the following resources (no explicit outputs):

- SNS Topic: `leapfrog-alerts-sns-topic`
- Lambda Function: `leapfrog-connector`
- IAM Role: `LeapfrogIntegrationRole`
- IAM Role: `leapfrog-connector-iam-role`
- SSM Parameters: `/leapfrog/api_key`, `/leapfrog/org_id`

## Resources Created

This module provisions:

- **1 SNS Topic** - Central hub for all AWS alerts
- **1 Lambda Function** - Processes and forwards events to Leapfrog
- **2 IAM Roles** - Integration access role and Lambda execution role
- **3 IAM Policies** - Permissions for Integration, Lambda, and SSM access
- **2 SSM Parameters** - Secure storage for API credentials
- **100+ CloudWatch Event Rules** - Monitors various AWS service events (based on enabled alerts)
- **100+ CloudWatch Event Targets** - Routes events to SNS topic
- **Multiple Event Subscriptions** - DMS, RDS, and Redshift event monitoring

## Security Considerations

- **API Key Storage**: Credentials are stored as SecureString in SSM Parameter Store with encryption at rest
- **IAM Least Privilege**: Lambda execution role has minimal permissions (CloudWatch Logs + SSM read)
- **Integration Role**: Scoped to Cost Explorer, Resource Groups, Config, CloudTrail, and SSM access
- **Cross-Account Access**: Integration role allows assumption from Leapfrog AWS account (`600627338216`)

## Examples

### Minimal Configuration

```hcl
module "leapfrog_integration" {
  source = "./modules/leapfrog-integration"

  leapfrog_api_key = var.leapfrog_api_key
  leapfrog_org_id  = var.leapfrog_org_id
}
```

### Selective Alert Monitoring

```hcl
module "leapfrog_integration" {
  source = "./modules/leapfrog-integration"

  leapfrog_api_key = var.leapfrog_api_key
  leapfrog_org_id  = var.leapfrog_org_id

  # Only monitor critical production services
  enable_lambda_failure_alerts = true
  enable_rds_failure_warning_alerts = true
  enable_ecs_task_termination_alerts = true
  
  # Disable non-critical alerts
  enable_game_lift_failure_alerts = false
  enable_transcribe_failure_alerts = false
  enable_sms_failure_alerts = false
}
```

### Monitor Specific Lambda Functions

```hcl
module "leapfrog_integration" {
  source = "./modules/leapfrog-integration"

  leapfrog_api_key = var.leapfrog_api_key
  leapfrog_org_id  = var.leapfrog_org_id

  # Only monitor these specific Lambda functions
  lambda_function_names = [
    "production-api-handler",
    "production-data-processor",
    "production-event-consumer"
  ]
}
```

## Troubleshooting

### Lambda Function Not Receiving Events

1. Check SNS topic subscription: `aws sns list-subscriptions-by-topic --topic-arn <topic-arn>`
2. Verify Lambda has permission to be invoked by SNS
3. Check CloudWatch Logs for Lambda execution errors: `/aws/lambda/leapfrog-connector`

### API Key Issues

1. Verify SSM parameter exists: `aws ssm get-parameter --name /leapfrog/api_key --with-decryption`
2. Ensure Lambda IAM role has permission to read SSM parameters
3. Check API key validity in Leapfrog Platform dashboard

### No Alerts Being Sent

1. Verify CloudWatch Event Rules are enabled
2. Check SNS topic has proper permissions for AWS services to publish
3. Review Lambda function logs for processing errors
4. Confirm `enable_*` variables are set to `true` for desired alerts

## Maintenance

### Updating API Credentials

```bash
# Update API key
aws ssm put-parameter --name /leapfrog/api_key --value "new-api-key" --type SecureString --overwrite

# Update Organization ID
aws ssm put-parameter --name /leapfrog/org_id --value "new-org-id" --type String --overwrite
```

### Viewing Lambda Logs

```bash
aws logs tail /aws/lambda/leapfrog-connector --follow
```

## Version History

- **v1.0.0** - Initial release with comprehensive AWS service monitoring

## Support

For issues, questions, or feature requests:
- Contact: Leapfrog Support
- Documentation: [Leapfrog Platform Docs](https://docs.leapfrog.io)

## License

Proprietary - Leapfrog Technologies Inc.
