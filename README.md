# Terraform Mastery Lab

A complete **60-day Terraform learning program** from zero to production-level AWS Terraform engineering.

## Start Here

1. [60-Day Calendar](./CALENDAR.md)
2. [Complete Syllabus](./SYLLABUS.md)
3. [Study Method](./STUDY_METHOD.md)
4. [Day 01](./days/day-01-foundations.md)
5. [Day 02](./days/day-02-cli-workflow.md)
6. Continue through [Day 60](./days/day-60-capstone-3-and-interview-bootcamp.md)

## Course Method

**Learn → Notes → Example → Practical → Break/Fix → Test → Diagram → Interview Q&A → Git**

Every day contains a learning objective, notes, example, hands-on exercise, production checklist, troubleshooting challenge and interview questions.

## Curriculum

| Phase | Days | Focus |
|---|---:|---|
| Foundations | 1–6 | Terraform, HCL, CLI, providers, resources |
| Language | 7–12 | Variables, types, expressions, loops, functions |
| Engine & State | 13–18 | Data sources, graph, state, remote state, state operations |
| Modules & Migration | 19–24 | Environments, modules, versioning, moved, import |
| AWS Networking | 25–30 | VPC, NAT, endpoints, security, IAM, EC2, ALB |
| AWS Services | 31–36 | ASG, S3, RDS, Lambda, DNS/TLS, ECR |
| Containers & Quality | 37–42 | ECS, EKS, CI/CD, testing |
| Production Controls | 43–48 | Security, policy, cost, secrets, drift, lifecycle |
| Enterprise | 49–54 | Upgrades, multi-account, multi-region, governance |
| Capstones | 55–60 | DR, troubleshooting, reviews, projects, interviews |

## Visual Learning

See [Diagrams](./diagrams/README.md) for Mermaid architecture and workflow diagrams.

## Production Projects

See [Projects](./projects/README.md).

1. Secure static website.
2. Production ECS platform.
3. Multi-account platform foundation.
4. Enterprise reference platform.

## Lab Rules

See [Labs](./labs/README.md). Use a sandbox AWS account, budgets, cleanup procedures and never commit credentials or state.

## Current Terraform Principles

Terraform configuration is made of top-level .tf files in a module; nested directories are separate modules. citeturn0search4turn0search5

Modules are reusable collections of resources. HashiCorp recommends keeping module trees relatively flat and using composition instead of unnecessary deep nesting. citeturn0search3turn0search7

The AWS provider is maintained in the Terraform Registry; check the current provider release before selecting a production version constraint. citeturn0search2
