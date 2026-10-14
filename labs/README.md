# Hands-On Labs

Each executable Terraform lab belongs in a separate directory to isolate state and provider configuration.

## Learning sequence

| Lab | Focus | Resource creation |
|---|---|---|
| [00 — Local basics](./00-local-basics/) | CLI, language, testing | Designed to be cloud-free |
| [01 — S3 static data](./01-s3-static-data/) | AWS storage security | AWS costs may apply |
| [02 — Azure storage](./02-azure-storage/README.md) | Azure hierarchy, RBAC and storage | Runbook only; build in sandbox |
| [03 — GCP storage](./03-gcp-storage/README.md) | Project/IAM boundary and Cloud Storage | Runbook only; build in sandbox |

## Lab standard

Executable roots should include `main.tf`, `variables.tf`, `outputs.tf`, `versions.tf`, `README.md`, and tests where practical. Root-level ignore rules protect state and local secrets.

## Lab lifecycle

`init → fmt → validate → plan → review → apply → inspect → test → destroy → verify cleanup`

## Safety

Use a sandbox account/subscription/project with a budget or cost alert. Review every plan before apply. Never commit credentials, secret tfvars, state, plan files or `.terraform` directories. Some resources continue billing until destroyed or manually cleaned up.
