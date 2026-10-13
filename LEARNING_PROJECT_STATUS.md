# Terraform Learning Project — Completion Tracker

This is a learning repository, not a claim that every AWS architecture has been deployed or certified for production. Completion means every topic has a practical exercise, reproducible validation steps, expected evidence, troubleshooting guidance, and a review gate.

## Learning outcomes

- [ ] Explain Terraform's configuration, provider, dependency graph, plan, state, and remote API relationship.
- [ ] Build and test HCL expressions, typed variables, locals, outputs, validation, checks, and lifecycle behavior.
- [ ] Use state safely: remote backend, locking, versioning, migration, import, moved blocks, recovery.
- [ ] Design reusable module contracts and test changes before release.
- [ ] Build AWS networking, IAM, compute, data, serverless, and container foundations.
- [ ] Validate infrastructure changes through CI and review plans before apply.
- [ ] Identify common IaC security findings and document justified exceptions.
- [ ] Diagnose drift, provider upgrades, failed deployments, access errors, and cost surprises.
- [ ] Deliver the static website, ECS, and EKS capstones in a disposable AWS account.
- [ ] Explain architecture trade-offs and incident response without relying on copied commands.

## Repository tracks

| Track | Location | Evidence |
|---|---|---|
| Fundamentals | `labs/00-local-basics` | `terraform test`, validate, plan |
| S3 security | `labs/01-s3-static-data` | S3 plan, security configuration, cleanup |
| State | `projects/00-state-bootstrap` | versioned encrypted bucket, lockfile backend example |
| Static site | `projects/01-static-site` | CloudFront URL, private origin test, teardown |
| ECS platform | `projects/02-ecs-platform` | image push, service healthy, RDS connectivity and rollback evidence |
| EKS platform | `projects/03-eks-platform` | cluster access, workload, ingress, autoscaling and cleanup |
| Daily theory/practice | `days/` | practical evidence + self-assessment |
| Review and interview | `exercises/`, `references/` | completed scenarios and explanations |

## Completion definition

A topic is complete only when the learner can:
1. Explain the concept in their own words.
2. Write or modify the configuration without blindly copying.
3. Predict the important plan changes before running the plan.
4. Run formatting, validation, and relevant tests.
5. Introduce a controlled failure and diagnose the cause.
6. Describe security, cost, availability, and recovery trade-offs.
7. Save evidence without committing credentials, state, or sensitive plan output.

## AWS safety

Use a dedicated sandbox account. Run `terraform plan` and inspect it before `apply`. NAT gateways, ALBs, RDS, EKS, CloudFront and data transfer can incur charges. Destroy only disposable environments and verify retained data/state before cleanup.

CI validation proves configuration-level checks passed for the commit; it does not prove successful deployment or runtime health in an AWS account.
