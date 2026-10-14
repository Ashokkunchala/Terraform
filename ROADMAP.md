# Terraform Mastery Roadmap

## Goal
Build the ability to design, implement, review, test, secure, automate, troubleshoot, refactor and operate Terraform across AWS, Microsoft Azure and Google Cloud. Learn provider-specific identity and resource models rather than assuming cloud services are interchangeable.

## Phase 1 — Foundations
Terraform mental model, CLI lifecycle, HCL, providers, resources, typed variables, outputs, locals and state. Deliverable: explain and demonstrate init, fmt, validate, plan and apply without notes.

## Phase 2 — Core engineering
Expressions, collections, for expressions, functions, data sources, dependency graph, modules, module versioning, import/moved blocks, testing, state recovery, drift and environments. Deliverable: reusable module, test, and safe refactor.

## Phase 3 — AWS platform engineering
Use the existing AWS labs/projects: VPC/subnets/routes, security groups, IAM, EC2, ALB, S3, RDS, ECR, ECS/Fargate, EKS, DNS/TLS, autoscaling, remote state and recovery. Deploy only in a disposable sandbox with cost controls; verify then tear down.

## Phase 4 — Azure foundations
Follow [Azure storage lab](./labs/02-azure-storage/README.md). Learn tenant/subscription/resource group, AzureRM provider, naming/location constraints, Azure RBAC, storage security, remote state and cleanup.

## Phase 5 — Google Cloud foundations
Follow [GCP storage lab](./labs/03-gcp-storage/README.md). Learn organization/folder/project, service accounts, IAM bindings, Cloud Storage access controls, GCS backend, cost and cleanup.

## Phase 6 — Multi-cloud production delivery
Provider aliases, account/subscription/project boundaries, separate state roots, identity federation, CI plan/apply separation, policy/security checks, cost governance, provider upgrades and disaster recovery.

## Phase 7 — Interview capstone
Use the [multi-cloud interview bank](./references/multi-cloud-interview-bank.md) and [design exercises](./exercises/04-multi-cloud-design.md). Practice state-lock failure, drift, accidental replacement, wrong target cloud, CI identity failure, public storage, provider upgrade and failed deployment.

## Completion gates

- **Gate A — Fundamentals:** explain provider, module, graph, state, plan and apply; write a small validated module.
- **Gate B — Cloud-specific skills:** build and clean up a small lab in each cloud, or document why live prerequisites are unavailable; explain identity, networking and storage security differences.
- **Gate C — Production review:** spot state, IAM, secret exposure, replacement, testing, cost, observability and recovery risks in a PR.
- **Gate D — Interview readiness:** score at least 8/10 on each design exercise and explain why rejected approaches are weaker.

A topic is complete only when you can modify code without blindly copying, predict the plan, validate, diagnose a controlled failure, and explain security/cost/reliability trade-offs.
