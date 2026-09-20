# Terraform Mastery Lab

A structured, hands-on Terraform curriculum from zero to production engineering.

## Start Here

1. Read [ROADMAP.md](./ROADMAP.md).
2. Start [Day 01](./days/day-01-foundations.md).
3. Use an isolated AWS sandbox for cloud labs.
4. Complete each lab before moving forward.

## Learning Loop

**Learn → Predict → Code → Plan → Apply → Inspect → Break/Fix → Test → Explain → Interview**

Recommended daily effort: **90–150 minutes**.

## Repository Structure

```
Terraform/
├── days/                  # Daily lessons + labs + interview Q&A
├── exercises/             # Topic-focused practice
├── deep-dives/            # Detailed engineering guides
├── diagrams/              # Mermaid diagrams
├── projects/              # Progressive production projects
├── references/            # Cheat sheets and troubleshooting
├── templates/             # Reusable starter layouts
├── ROADMAP.md             # Master curriculum
├── STUDY_METHOD.md        # Study and assessment method
├── PROJECTS.md            # Project ladder
└── SUMMARY.md             # Repository index
```

## Curriculum

| Phase | Days | Outcome |
|---|---:|---|
| Foundations | 1–7 | HCL, CLI, providers, resources, variables, outputs, state |
| Core Engineering | 8–14 | Expressions, collections, data sources, dependencies, modules |
| AWS Architecture | 15–21 | VPC, IAM, EC2, ALB, Route 53, RDS |
| Production Engineering | 22–28 | Remote state, CI/CD, security, testing, import, refactoring |
| Expert Operations | 29–35 | Drift, secrets, cost, multi-account, multi-region, recovery |
| Capstones | 36–45 | End-to-end production-style projects |

## Current State Guidance

The current HashiCorp documentation supports native S3 state locking with `use_lockfile = true`; DynamoDB-based locking is documented as deprecated. S3 bucket versioning is recommended for state recovery. citeturn726687search0

Terraform's core CLI workflow is built around `init`, `validate`, `plan`, `apply`, and `destroy`. citeturn726687search4

