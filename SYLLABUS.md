# Complete Terraform Syllabus

## Foundations
IaC, declarative model, Terraform architecture, CLI lifecycle, HCL, files, providers, resources, addresses, variables, locals and outputs.

## Terraform Language
Primitive and complex types, expressions, conditionals, for expressions, functions, dynamic blocks, meta-arguments, validation, preconditions and postconditions.

## Terraform Engine
Dependency graph, unknown values, planning, refresh, lifecycle, replacement, drift and resource addressing.

## State
Local state, remote state, S3 backend, locking, encryption, versioning, migration, inspection, state surgery and recovery.

## Environments
Workspaces, directory-based environments, account boundaries, promotion models and environment-specific configuration.

## Modules
Root/child modules, contracts, inputs, outputs, composition, sources, versioning, registry, testing, documentation and release strategy.

## Import and Refactoring
Declarative import blocks, generated configuration, moved blocks, resource address migration and safe refactoring.

## AWS Core
VPC, CIDR, subnets, routes, NAT, endpoints, security groups, NACLs, IAM, EC2, ALB, ASG, S3, RDS, Lambda, Route 53, ACM and ECR.

## Containers
ECS, Fargate, task definitions, services, ALB integration, IAM roles, autoscaling, logs and EKS fundamentals.

## Production Engineering
GitHub Actions, plan/apply separation, approvals, terraform test, TFLint, Checkov, policy as code, cost estimation, secrets and observability.

## Operations
Drift detection, troubleshooting, upgrades, provider lock files, disaster recovery, state recovery, incident response and production code review.

## Enterprise
Multi-account, multi-region, provider aliases, landing zones, governance, centralized state and private module platforms.

## Career
Architecture reviews, design trade-offs, troubleshooting scenarios, incident questions, code reviews and Terraform interview preparation.

Terraform configuration consists of top-level .tf files in a module; nested directories are separate modules. citeturn0search4turn0search5

Modules are reusable collections of resources, and HashiCorp recommends avoiding unnecessarily deep module trees. citeturn0search3turn0search7

The current AWS provider is maintained in the Terraform Registry; check its current version before pinning a production dependency. citeturn0search2
