# Complete Terraform Syllabus

## Foundations
Infrastructure as Code, declarative model, Terraform architecture, CLI lifecycle, HCL, providers, resources, resource addresses, variables, locals, outputs and dependency graph.

## Terraform language
Primitive and complex types, expressions, conditionals, for expressions, functions, dynamic blocks, meta-arguments, validation, preconditions and postconditions.

## State and lifecycle
Local/remote state, locking, encryption, versioning, migration, inspection, recovery, drift, import blocks, moved blocks, state operations and resource replacement.

## Modules and environments
Module contracts, inputs/outputs, testing, versioning, registry, root/child modules, workspaces, separate environment roots and promotion models.

## AWS
VPC, subnets, routes, NAT, endpoints, security groups, IAM, EC2, ALB, ASG, S3, RDS, Lambda, Route 53, ACM, ECR, ECS/Fargate and EKS.

## Microsoft Azure
Tenant/subscription/resource-group/resource hierarchy, AzureRM provider, Azure RBAC scopes, VNets, subnets, NSGs, storage accounts/containers, managed identities, remote state, naming constraints and policy.

## Google Cloud
Organization/folder/project hierarchy, Google provider, service accounts and IAM, VPC networks, subnets, firewall rules, Cloud Storage, project/location scope, remote state and organization policy.

## Cross-cloud engineering
Provider aliases, multiple identities, environment boundaries, shared module contracts, cloud-specific modules, state isolation, workload identity federation, cost controls, governance and operational trade-offs. Avoid abstractions that hide meaningful provider differences.

## Production engineering
GitHub Actions, plan/apply separation, approvals, Terraform tests, TFLint, Checkov, policy as code, cost estimation, secrets management, observability, backups and recovery.

## Career readiness
Architecture reviews, design trade-offs, troubleshooting scenarios, incident response and Terraform interview preparation.

## Multi-cloud study assets
- [Multi-cloud learning path](./MULTI_CLOUD_LEARNING_PATH.md)
- [Multi-cloud interview bank](./references/multi-cloud-interview-bank.md)
- [Multi-cloud design exercises](./exercises/04-multi-cloud-design.md)
- [Azure storage lab runbook](./labs/02-azure-storage/README.md)
- [Google Cloud storage lab runbook](./labs/03-gcp-storage/README.md)

Official provider references:
- https://registry.terraform.io/providers/hashicorp/aws/latest/docs
- https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs
- https://registry.terraform.io/providers/hashicorp/google/latest/docs
