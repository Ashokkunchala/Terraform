# Project 02 — Production ECS/Fargate Platform

Target architecture:

```text
Internet
   |
ALB (public subnets)
   |
ECS/Fargate (private subnets)
   +-- application service
   +-- worker service
   |
RDS / Secrets Manager
```

Build order: VPC -> security groups -> ECR -> ECS cluster -> ALB -> services/autoscaling -> RDS -> Secrets Manager -> CloudWatch -> CI/security/cost controls.

Keep each layer modular and testable. Never commit credentials or real secrets.
