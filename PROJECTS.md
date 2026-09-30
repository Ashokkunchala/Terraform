# Terraform Project Ladder

## Project 00 — Remote State Bootstrap
S3 state bucket with versioning, encryption, public-access blocking, and S3-native locking configuration.

## Project 01 — Secure Static Website
Architecture: Browser → CloudFront → private S3.
Skills: S3 security, CloudFront Origin Access Control, HTTPS redirect, objects, policies and teardown.

## Project 02 — Production ECS Platform
Architecture: Internet → ALB → ECS/Fargate → private RDS; ECR, Secrets Manager, IAM, CloudWatch and autoscaling support the workload.
Skills: networking, security groups, ECS, ALB, ECR, RDS, Secrets Manager, IAM, autoscaling, state and CI validation.

## Advanced expansion track
The curriculum documents multi-account, multi-region, landing-zone, policy-as-code, cost, DR and enterprise governance patterns. These remain advanced design exercises until they can be implemented against real account/organization boundaries.

## Completion checklist for executable projects
- [x] Architecture and assumptions
- [x] README and deployment commands
- [x] Module interfaces
- [x] Terraform/provider constraints
- [x] fmt check in CI
- [x] validate in CI
- [x] Native Terraform test for the cloud-free lab
- [x] Security controls in infrastructure code
- [x] Cost-aware defaults
- [x] CI workflow
- [x] Remote-state bootstrap
- [x] Teardown procedure
