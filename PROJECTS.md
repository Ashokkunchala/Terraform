# Terraform Project Ladder

## Project 1 — Secure Static Website
Architecture: GitHub → Terraform → S3/CloudFront/ACM/Route 53.
Skills: resources, variables, outputs, modules, TLS, DNS, monitoring and CI.
Production criteria: secure state, TLS, tagging, version constraints, plan review, security scan, cost estimate and teardown.

## Project 2 — Production ECS Platform
Architecture: Internet → ALB → ECS/Fargate → private RDS; Secrets Manager and IAM support the workload.
Skills: networking modules, ECS, ALB, RDS, Secrets Manager, IAM, autoscaling, CloudWatch, remote state and GitHub Actions.
Production criteria: least privilege, private workloads, encryption, health checks, autoscaling, isolated state, plan review, approval gate, security scan, cost review and recovery runbook.

## Project 3 — Multi-Account Platform Foundation
Architecture: Platform account → Dev / Stage / Prod accounts, each with isolated VPCs and controlled access.
Skills: provider aliases, AssumeRole, account boundaries, centralized state, logging, guardrails, reusable modules, CI/CD and governance.

## Project 4 — Enterprise Reference Platform
Design a platform for multiple teams, accounts, regions and application stacks. Document ownership boundaries, module APIs, state boundaries, promotion workflow, incident recovery and cost controls.

## Completion Checklist
- [ ] Architecture diagram
- [ ] README and assumptions
- [ ] Module interfaces documented
- [ ] Terraform/provider versions pinned
- [ ] fmt check
- [ ] validate
- [ ] Tests
- [ ] Security scan
- [ ] Cost estimate
- [ ] CI plan workflow
- [ ] Approval workflow
- [ ] State recovery procedure
- [ ] Failure injection exercise
- [ ] Destroy/cleanup procedure
