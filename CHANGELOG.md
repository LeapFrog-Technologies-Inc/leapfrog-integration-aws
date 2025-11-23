# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.0] - 2025-11-23

### Added
- Initial release of Leapfrog Integration Terraform module
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
- CloudBuilder IAM role for Leapfrog platform access
- Granular enable/disable flags for all alert types (all enabled by default)
- Comprehensive documentation and examples

### Security
- API keys stored as SecureString in SSM Parameter Store
- Least-privilege IAM policies for Lambda execution
- Cross-account access role for CloudBuilder service

[1.0.0]: https://github.com/LeapfrogTechnologies/terraform-aws-leapfrog-integration/releases/tag/v1.0.0
