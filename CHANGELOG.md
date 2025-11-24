# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.3] - 2025-11-24

### Added
- New `trusted_principal_arns` variable to configure which AWS principals can assume the Leapfrog integration IAM role.

### Changed
- Leapfrog integration role trust policy now derives principals from `trusted_principal_arns` instead of a hardcoded AWS account ID.

## [1.0.2] - 2025-11-24

### Fixed
- Updated Leapfrog API endpoint to use `api.leapfrog.cloud` domain (production endpoint).
- Updated IAM role name to `LeapfrogIntegrationRole` and policy name to `LeapfrogIntegrationPolicy`.

## [1.0.1] - 2025-11-24

### Changed
- Enabled live API delivery in Lambda function (removed MOCK mode).
- Added proper error handling for API failures.
- Lambda now returns 200 OK even on API failure to prevent SNS retries for permanent errors.

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
