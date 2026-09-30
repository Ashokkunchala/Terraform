# Terraform Engineering Lab

A hands-on Terraform + AWS engineering repository for learning, building, testing, securing, and operating infrastructure.

The repository combines a 60-day curriculum with executable labs and complete reference projects. The learning material remains useful as the theory track; the projects are the implementation track.

## Quick start

### 1. Cloud-free fundamentals

```bash
cd labs/00-local-basics
terraform init
terraform fmt
terraform validate
terraform test
terraform plan
```

### 2. Secure AWS S3 lab

```bash
cd labs/01-s3-static-data
# create an untracked terraform.tfvars with bucket_name
terraform init
terraform validate
terraform plan
terraform apply
terraform destroy
```

### 3. Remote state bootstrap

```bash
cd projects/00-state-bootstrap
terraform init
terraform apply -var='bucket_name=YOUR-UNIQUE-BUCKET'
terraform output backend_example
```

### 4. Static website

```bash
cd projects/01-static-site
terraform init
terraform apply
terraform output cloudfront_url
```

### 5. ECS/Fargate platform

```bash
cd projects/02-ecs-platform
cp terraform.tfvars.example terraform.tfvars
terraform init
terraform validate
terraform plan
terraform apply
terraform output load_balancer_url
```

The ECS platform includes VPC, private networking, ALB, ECR, ECS/Fargate, autoscaling, RDS MySQL, managed Secrets Manager credentials, CloudWatch Logs, deployment rollback, and optional HTTPS.

## Repository map

- [60-day curriculum](./days/) — progressive Terraform learning.
- [Labs](./labs/) — small runnable exercises.
- [Projects](./projects/) — end-to-end AWS implementations.
- [Modules](./modules/) — reusable module contracts.
- [Deep dives](./deep-dives/) — advanced Terraform design.
- [Exercises](./exercises/) — practice questions and scenarios.
- [Diagrams](./diagrams/) — architecture and state workflows.
- [References](./references/) — commands and interview preparation.

## CI quality gates

GitHub Actions runs recursive formatting and validation for every executable lab/project and runs the native Terraform test for the local lab.

## State and secrets

Use a dedicated remote state bucket for shared environments. The state bootstrap project enables versioning, public-access blocking, and encryption. Generated backend examples use S3-native locking with `use_lockfile = true`.

Never commit credentials, secret `.tfvars`, Terraform state, plan files, or `.terraform` directories.

## Engineering method

**Learn → Read code → Plan → Apply in a sandbox → Break it → Diagnose → Test → Document → Commit**

## Production checklist

- [ ] Remote state and locking
- [ ] Least-privilege IAM
- [ ] Encryption
- [ ] Input validation
- [ ] Standard tags
- [ ] Format + validate + test
- [ ] Security scanning
- [ ] Cost controls
- [ ] Plan review
- [ ] Monitoring and alarms
- [ ] Backup and recovery
- [ ] Disaster recovery procedure
- [ ] Teardown procedure
- [ ] Provider upgrade process
