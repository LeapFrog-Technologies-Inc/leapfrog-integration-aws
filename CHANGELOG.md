# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.0] - 2025-11-24

### Added
- Initial public release of Leapfrog Integration Terraform module
- Support for 30+ AWS service monitoring including:
  - Compute: Lambda, EC2, ECS, Batch
  - Database: RDS, DMS, Redshift
  - Analytics: EMR, Glue, IoT Analytics
  - CI/CD: CodeBuild, CodeDeploy, CodePipeline
  - Operations: SSM, OpsWorks, Step Functions
  - Storage: EBS, DataSync
  - Security: Config, KMS, Macie
  - Media: MediaPackage, MediaLive, MediaConvert
  - ML: SageMaker (Training, Transform, Hyperparameter Tuning)
  - Other: Transcribe, Signer, GameLift, Health, Trusted Advisor
- SNS topic for centralized alert aggregation
- Lambda function for event processing and forwarding to Leapfrog Platform
- Secure credential storage via AWS SSM Parameter Store
- IAM role for Leapfrog Integration service access
- Prowler SaaS scan permissions for security scanning compatibility
- Read-only access to 40+ AWS services for Prowler integration (Account, AppStream, Backup, Bedrock, CloudTrail, CodeArtifact, CodeBuild, Cognito, DLM, DRS, Directory Service, DynamoDB, EC2, ECR, EFS, Glue, Lambda, Lightsail, Logs, Macie, S3, Security Hub, Service Catalog, Shield, SSM, SSM Incidents, Support, Tags, Well-Architected)
- API Gateway read permissions for Prowler integration (REST APIs and HTTP APIs)
- Configurable `trusted_principal_arns` variable for cross-account access control
- Granular enable/disable flags for all alert types (all enabled by default)
- Comprehensive documentation and examples

### Security
- API keys stored as SecureString in SSM Parameter Store with encryption at rest
- Least-privilege IAM policies for Lambda execution
- Configurable cross-account access via `trusted_principal_arns` variable
- Integration role scoped to Cost Explorer, Resource Groups, Config, CloudTrail, SSM access, and Prowler SaaS scan permissions
