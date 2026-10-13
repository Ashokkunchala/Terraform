# Terraform Engineering Lab — Execution and Validation Guide

This repository contains a Terraform curriculum, focused labs, reusable modules, and AWS reference projects. Use the local lab first, then progress to AWS projects only after understanding the plan and costs.

## Important distinction: CI validation vs AWS deployment

GitHub Actions can check formatting, initialize provider/module dependencies, validate configurations, run native tests, and scan code for common infrastructure risks. These checks do **not** prove a resource can be deployed successfully in your AWS account. Deployment also depends on account permissions, quotas, service availability, provider/module compatibility, and your real variable values.

## Recommended learning sequence

1. `labs/00-local-basics`: learn HCL, variables, locals, validation and native Terraform tests without creating AWS resources.
2. `labs/01-s3-static-data`: practice S3 security controls. Use a unique bucket name and review costs.
3. `projects/00-state-bootstrap`: create a dedicated state bucket; retain state versioning and use S3 lockfiles in consumer backends.
4. `projects/01-static-site`: understand private S3 origins and CloudFront.
5. `projects/02-ecs-platform`: review VPC, NAT, ALB, ECS/Fargate, ECR, RDS, Secrets Manager, and autoscaling.
6. `projects/03-eks-platform`: learn EKS, networking, node groups, access management and Kubernetes add-ons.

## Local checks

For each root module you intend to use:

```bash
terraform fmt -check -recursive
cd path/to/root-module
terraform init -backend=false
terraform validate
terraform plan
```

Run `terraform test` in `labs/00-local-basics`. Use `terraform init -backend=false` only for validation; for an actual deployment, initialize the intended backend and inspect state configuration before planning.

## AWS safety checklist

Before `terraform apply`:

- Confirm the AWS identity and selected region.
- Review every resource in `terraform plan`, particularly NAT gateways, ALBs, RDS, EKS, and log retention.
- Confirm private subnet routing, security-group paths, and least-privilege IAM.
- Confirm that secrets are not declared as plaintext values in committed files.
- Confirm backup retention, deletion protection and final snapshot policies for stateful resources.
- Apply first in a disposable sandbox account; never point a learning project at production by accident.
- Keep a teardown and recovery plan. Do not destroy a production database without explicit approval.

## Security scanning

The CI workflow runs Checkov against Terraform and Kubernetes manifests in soft-fail mode initially. This is a discovery gate: review findings and remediate applicable issues before treating any project as production-ready. A clean scan alone does not certify security.

## Remote state

The state bootstrap project generates an S3 backend example using `use_lockfile = true`. The bucket must exist before the consuming root's backend is initialized. Protect it with least-privilege access, encryption, versioning, and public-access blocking. State can contain sensitive values even when Terraform outputs are marked sensitive.

## Before calling a project production-ready

- [ ] Run format, validation, tests, lint, and security scans.
- [ ] Inspect the full plan in the target account.
- [ ] Test deployment, health checks, rollback, and teardown in a sandbox.
- [ ] Establish state backup/recovery and access controls.
- [ ] Configure monitoring/alerts, backups, cost budgets, and ownership.
- [ ] Document any accepted scanner findings and architecture trade-offs.

