# Terraform Engineering Lab

A hands-on Terraform + AWS engineering repository for learning, building, testing, securing, and operating infrastructure.

This repository combines a structured 60-day curriculum with real executable Terraform labs and production-style project blueprints.

## Repository map
- [60-day curriculum](./days/)
- [Hands-on labs](./labs/)
- [Production projects](./projects/)
- [Reusable modules](./modules/)
- [Deep dives](./deep-dives/)
- [Diagrams](./diagrams/)
- [References](./references/)

## Start with the executable path
1. [Lab 00: Local Terraform Basics](./labs/00-local-basics/README.md)
2. [Lab 01: Secure S3 Foundation](./labs/01-s3-static-data/README.md)
3. [Project 01: Secure Static Website](./projects/01-static-site/README.md)
4. [Project 02: Production ECS/Fargate Platform](./projects/02-ecs-platform/README.md)
5. Continue with the [60-day curriculum](./days/)

## Engineering workflow

```bash
terraform fmt -recursive
terraform init -backend=false
terraform validate
terraform plan
terraform apply
terraform destroy
```

For AWS labs, confirm the active identity first:

```bash
aws sts get-caller-identity
```

Never commit credentials, secret tfvars, Terraform state, plan files, or .terraform directories.

## State
Team environments should use a remote backend with restricted IAM access, S3 versioning, and state locking. Current HashiCorp guidance supports S3-native locking with use_lockfile = true; legacy DynamoDB-based locking is deprecated.

See [state management](./deep-dives/terraform-state-management.md).

## Learning method
Learn -> Read code -> Run plan -> Apply in a sandbox -> Break it -> Diagnose -> Test -> Document -> Commit

## Production checklist
- [ ] Version constraints
- [ ] Remote state strategy
- [ ] Least-privilege CI identity
- [ ] Input validation
- [ ] Encryption
- [ ] Tags
- [ ] Format + validate
- [ ] Lint/security checks
- [ ] Plan review
- [ ] Tests
- [ ] Cost review
- [ ] Recovery runbook
- [ ] Teardown procedure

The original 60-day learning material remains intact; this rework adds an executable engineering layer around it.