# Terraform Engineering Lab

A hands-on Terraform engineering repository for learning, building, testing, securing, and operating infrastructure across AWS, Microsoft Azure, and Google Cloud.

## Start here: Daily practice and multi-cloud learning

- [Daily practice levels](./DAILY_PRACTICE_LEVELS.md) — daily routine, progressive skill levels, self-scoring, break/fix exercises and a reusable practice log.
- [Daily lesson standard](./DAILY_LESSON_STANDARD.md) — quality and completion criteria for each lesson.

## Start here: Multi-cloud learning and interviews

- [Multi-cloud learning path](./MULTI_CLOUD_LEARNING_PATH.md) — provider comparisons, a starter plan, state/security guidance, and capstone.
- [Multi-cloud interview bank](./references/multi-cloud-interview-bank.md) — questions, troubleshooting scenarios, and a self-scoring rubric.
- [Multi-cloud design exercises](./exercises/04-multi-cloud-design.md) — architecture design, identity failures, state incidents, and destructive-plan drills.

Recommended order: cloud-free Terraform basics → AWS labs/projects → Azure starter lab → GCP starter lab → state/CI/security → interview capstone.

## Cloud-free fundamentals

```bash
cd labs/00-local-basics
terraform init
terraform fmt
terraform validate
terraform test
terraform plan
```

## AWS hands-on labs and projects

- [S3 security lab](./labs/01-s3-static-data)
- [Remote state bootstrap](./projects/00-state-bootstrap/README.md)
- [Secure static website](./projects/01-static-site/README.md)
- [ECS/Fargate platform](./projects/02-ecs-platform/README.md)
- [EKS platform](./projects/03-eks-platform/README.md)

## Azure and GCP starter labs

- [Azure resource group and storage](./labs/02-azure-storage/README.md)
- [Google Cloud project and storage](./labs/03-gcp-storage/README.md)

The Azure and GCP folders currently provide learning runbooks, not complete executable Terraform roots. Build and validate the configuration in a sandbox before applying.

## Repository map

- [Curriculum](./days/) — progressive Terraform learning.
- [Labs](./labs/) — small exercises and provider runbooks.
- [Projects](./projects/) — end-to-end AWS implementations.
- [Modules](./modules/) — reusable module examples.
- [Deep dives](./deep-dives/) — advanced design.
- [Exercises](./exercises/) — scenarios and design reviews.
- [References](./references/) — commands and interview preparation.
- [Learning project status](./LEARNING_PROJECT_STATUS.md)

## Safe engineering workflow

**Learn → Read code → Draw the architecture → fmt → init → validate → plan → review → apply in a sandbox → verify → test → destroy → verify cleanup.**

Never commit credentials, secret tfvars, Terraform state, plan files, or `.terraform` directories. Review every plan, especially database replacement/deletion and networking changes. Use restricted remote state with locking, versioning, and a tested recovery process where supported.

## Production review checklist

- [ ] State, locking, and recovery
- [ ] Least-privilege identity and CI federation
- [ ] Encryption and private access
- [ ] Typed inputs and stable module interfaces
- [ ] Standard tags/labels
- [ ] Formatting, validation, tests, and security scanning
- [ ] Plan and destructive-change review
- [ ] Cost controls and cleanup verification
- [ ] Monitoring, backup, disaster recovery
- [ ] Provider/module upgrade process

CI validation does not prove successful cloud deployment or runtime health; those require separate evidence.
