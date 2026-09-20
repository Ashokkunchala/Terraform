# Terraform Mastery Roadmap

## Goal

Become able to design, implement, review, test, secure, automate, troubleshoot, refactor, and operate Terraform for AWS production environments.

## 45-Day Curriculum

### Phase 1 — Foundations

| Day | Topic | Deliverable | Interview Focus |
|---|---|---|---|
| 01 | IaC + Terraform mental model | First configuration | Declarative vs imperative |
| 02 | CLI workflow | init/fmt/validate/plan/apply/destroy lab | CLI behavior |
| 03 | HCL syntax | Blocks, attributes, expressions | HCL structure |
| 04 | Providers | AWS provider setup | Provider and aliases |
| 05 | Resources | S3 lab | Resource addressing |
| 06 | Variables + outputs | Typed module contract | Types, validation, sensitive |
| 07 | State | State inspection lab | State, drift, locking |

### Phase 2 — Core Engineering

| Day | Topic | Deliverable | Interview Focus |
|---|---|---|---|
| 08 | Expressions | Conditions/operators | Evaluation |
| 09 | Collections | map/list/set/object/tuple | Type constraints |
| 10 | for expressions | Resource maps | for vs for_each |
| 11 | Functions | Function laboratory | merge, try, coalesce, flatten |
| 12 | Data sources | AMI/VPC/subnet discovery | Data vs resource |
| 13 | Dependencies | Dependency graph lab | Implicit/explicit deps |
| 14 | Modules | Reusable S3/VPC module | Module design/versioning |

### Phase 3 — AWS Networking & Compute

| Day | Topic | Deliverable | Interview Focus |
|---|---|---|---|
| 15 | VPC | VPC/subnet/routes | CIDR design |
| 16 | NAT + endpoints | Private egress | NAT vs endpoints |
| 17 | IAM | Roles and policies | Trust vs permissions |
| 18 | EC2 | Private compute | AMI and bootstrap |
| 19 | ALB | Public ALB/private targets | Listeners/target groups |
| 20 | DNS + ACM | DNS + TLS | Validation |
| 21 | RDS | Private DB tier | Security/backup |

### Phase 4 — Production Engineering

| Day | Topic | Deliverable | Interview Focus |
|---|---|---|---|
| 22 | Remote state | S3 backend | Locking/recovery |
| 23 | Environments | Dev/stage/prod layout | Workspaces vs directories |
| 24 | CI/CD | PR plan workflow | Plan/apply separation |
| 25 | IaC security | Checkov + TFLint | Shift-left controls |
| 26 | Terraform tests | Native test suite | Unit-like vs integration |
| 27 | Import | Existing infrastructure | Import workflows |
| 28 | Refactoring | moved block migration | Safe address changes |

### Phase 5 — Expert Operations

| Day | Topic | Deliverable | Interview Focus |
|---|---|---|---|
| 29 | Preconditions/postconditions | Invariant checks | Validation semantics |
| 30 | Drift | Drift response playbook | Detection/remediation |
| 31 | Secrets | Secret-safe architecture | State exposure |
| 32 | Cost | Infracost workflow | Cost review |
| 33 | Multi-account | Provider aliases | AssumeRole |
| 34 | Multi-region | Regional providers | Provider topology |
| 35 | Disaster recovery | State recovery runbook | Incident response |

### Phase 6 — Capstones

| Days | Project | Outcome |
|---|---|---|
| 36–38 | Secure static platform | S3 + CloudFront + TLS + DNS |
| 39–42 | Production ECS platform | VPC + ALB + ECS + RDS + secrets |
| 43–45 | Multi-account platform | Provider aliases + boundaries + CI/CD |

## Assessment Gates

### Gate A
Explain state, graph, resource, provider, module, variable, output, plan and apply without notes.

### Gate B
Review a pull request and identify state, IAM, secret, dependency, test, cost and recovery risks.

### Gate C
Design environment boundaries, provider aliases, module contracts, remote state, CI approval, security controls and recovery.

## Completion Rule

A day is complete only after you can explain the concept, write the configuration, predict the important part of the plan, inspect state, debug one intentional failure, and answer interview questions aloud.
