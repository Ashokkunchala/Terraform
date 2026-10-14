# Infrastructure Project Ladder

## Existing AWS projects

- **Project 00 — Remote State Bootstrap:** S3 state bucket with versioning, encryption, public-access blocking and an S3-native locking backend example.
- **Project 01 — Secure Static Website:** private S3 + CloudFront Origin Access Control + HTTPS viewer redirect.
- **Project 02 — ECS/Fargate Platform:** VPC + ALB + ECR + ECS/Fargate + autoscaling + RDS MySQL + Secrets Manager + CloudWatch Logs.
- **Project 03 — EKS Platform:** AWS EKS, IAM, Kubernetes workload manifests, ingress and autoscaling exercises. Review cost and teardown requirements before deployment.

## Multi-cloud expansion

Start with [Azure storage](../labs/02-azure-storage/README.md) and [GCP storage](../labs/03-gcp-storage/README.md), then follow the [multi-cloud learning path](../MULTI_CLOUD_LEARNING_PATH.md). These are starter runbooks, not completed or production-certified cloud deployments.

Prefer separate root modules and state boundaries where ownership, lifecycle, credentials or blast radius differ. Standardize stable conventions such as naming, tags/labels, pipeline checks and output contracts, but preserve important differences in identity, networking, policy and service behavior.

## Project requirements

Every executable project should document architecture, prerequisites, apply/verify/destroy steps, security and cost concerns, validation and expected evidence. CI validation alone does not prove runtime deployment.
