# Multi-Cloud Terraform Learning Path (AWS, Azure, Google Cloud)

## Purpose

Turn this repository into a portfolio and interview-preparation lab for Terraform across AWS, Microsoft Azure, and Google Cloud Platform (GCP). Learn Terraform concepts once, then compare how each provider expresses identity, networking, compute, storage, state, policy, and delivery.

This is a learning path, not a claim that every cloud project has been deployed or production-certified. Execute cloud labs only in accounts/subscriptions/projects you own and can afford to use.

## Daily practice routine

Follow the [level-based daily practice plan](./DAILY_PRACTICE_LEVELS.md) for a 60–90 minute session, practice log, safe break/fix work, self-scoring, and weekly adjustment. The suggested seven sessions below are a starter cycle, not a deadline; repeat sessions until you can explain and troubleshoot the topic independently.

## How to use this track

For each module:

1. Read the concept and the provider comparison.
2. Draw the request/identity/network/state flow.
3. Run `terraform fmt -check`, `terraform init`, and `terraform validate`.
4. Review `terraform plan` before applying.
5. Apply only in an approved disposable sandbox.
6. Verify the deployed result using both Terraform outputs and the provider CLI/console.
7. Run `terraform destroy` where the lab is disposable, then verify cleanup.
8. Answer the interview questions aloud using: **definition → design choice → example → trade-off → production control**.

Never put credentials in HCL, commit secret tfvars, commit state/plan files, or paste secrets into logs. Marking a variable as `sensitive` redacts normal CLI output but does not make a value safe to store in state.

## Suggested 7-session starter plan

| Session | Focus | Hands-on deliverable |
|---|---|---|
| 1 | Terraform core, provider model, backend/state | Local-only lab, dependency graph, plan review |
| 2 | AWS fundamentals | Existing S3 lab; explain IAM role, region, backend and cost |
| 3 | Azure fundamentals | Resource group + storage account in a sandbox, with naming/region variables |
| 4 | GCP fundamentals | Project + Cloud Storage bucket in a sandbox, with project/region variables |
| 5 | Reusable modules and environment boundaries | One naming/tagging contract and documented inputs/outputs |
| 6 | CI, security and identity | Validate/format checks; design OIDC federation and plan approvals |
| 7 | Interview capstone | Compare three-cloud architecture, incident drills, cost/security review |

Repeat sessions and spend more time on areas you cannot explain or troubleshoot independently. Do not rush to deploy all providers in one weekend.

## Track A — Terraform core (cloud neutral)

Know the difference between configuration, provider plugin, resource, data source, module, state, dependency graph and remote API. Learn expression/type constraints, `count` vs `for_each`, `depends_on`, `lifecycle`, `moved` and `import` blocks, preconditions/postconditions, functions, provider lock file, state locking and drift.

Core workflow:

```bash
terraform fmt -check -recursive
terraform init
terraform validate
terraform plan -out=tfplan
terraform show tfplan
# Only after reviewing the plan in an approved sandbox:
terraform apply tfplan
```

Do not commit `tfplan`. It is ignored by the repository's `.gitignore`; keep it local or use a controlled CI artifact policy.

## Track B — Provider comparison

| Concern | AWS | Azure | Google Cloud |
|---|---|---|---|
| Main provider | `hashicorp/aws` | `hashicorp/azurerm` | `hashicorp/google` |
| Resource organization | Account, region, VPC and service resources | Tenant, subscription, resource group, region | Organization/folder, project, region/zone |
| Identity model to learn | IAM roles/policies, STS, workload federation | Microsoft Entra ID, service principals/managed identities, workload identity federation | IAM bindings, service accounts, Workload Identity Federation |
| Example network | VPC, subnets, route tables, security groups | VNet, subnets, NSGs, route tables | VPC network, subnets, firewall rules/routes |
| Example object storage | S3 bucket | Storage account + container | Cloud Storage bucket |
| State backend commonly used | S3 backend with locking/versioning and restricted access | AzureRM backend in a protected storage account | GCS backend in a protected Cloud Storage bucket |
| Compute examples | EC2, ECS/Fargate, EKS, Lambda | Virtual Machines, Container Apps, AKS, Functions | Compute Engine, Cloud Run, GKE, Cloud Functions/Cloud Run functions |
| Important interview nuance | Many resources are regional; some services are global | Azure resources frequently belong to a resource group/subscription boundary | Many resources are project-scoped; network and services can be regional/global |

Cloud names are conceptual mappings, not exact equivalents. Choose services based on security, operations, resiliency, performance and total cost—not names alone.

## Track C — Suggested lab ladder

### Lab 0: Cloud-free fundamentals
Use `labs/00-local-basics`. Learn formatting, validation, expressions, outputs, tests and the CLI lifecycle without creating billed cloud resources.

### Lab 1: AWS storage/security
Use `labs/01-s3-static-data`. Explain public-access blocking, encryption, versioning, IAM permissions and cleanup. Review the actual plan and inspect the bucket after apply.

### Lab 2: Azure resource boundary
Create a dedicated resource group and a storage account in a personal sandbox subscription. Use typed variables for location and name; include outputs, tags, resource-name constraints, TLS requirements, and a README describing deletion. Keep this in a separate root module.

### Lab 3: GCP project boundary
Create a Cloud Storage bucket in a dedicated sandbox project. Set location, uniform bucket-level access, public-access prevention and lifecycle controls appropriate to the exercise. Explain the relationship among organization/folder/project, service accounts and IAM.

### Lab 4: Same application, three clouds
Deploy a small static site or basic HTTP workload independently in each cloud. Keep modules provider-specific where APIs differ; standardize only the stable contract (name, environment, tags/labels, outputs). Write down where abstraction helps and where it hides important provider behavior.

### Lab 5: State and environment isolation
Compare local state with remote backend state. Build distinct state boundaries for dev and prod; document permissions, encryption, locking, versioning, recovery, migrations and blast radius. Do not place all production environments into one shared state file simply to reduce file count.

### Lab 6: CI/CD and identity
Pipeline should format, initialize safely, validate, lint, scan, test and produce a reviewable plan on pull requests. Apply from a protected branch/environment with approval and a short-lived federated identity where supported. Avoid long-lived cloud keys in repository secrets where federation is available.

### Lab 7: Interview capstone
Produce:
- Architecture diagram with trust, network and state boundaries.
- README with prerequisites, estimated cost risks, apply/verify/destroy.
- Example plan and sanitized validation output.
- Security, cost and reliability checklist.
- At least five diagnosed failure scenarios.
- A one-page comparison of AWS/Azure/GCP design decisions.

## Production checklist

- State storage encrypted, versioned/backed up, access controlled and locking enabled where supported.
- Separate state/identity boundaries for environments and teams based on blast radius.
- Short-lived CI identity with least privilege.
- No secrets in source, plans, logs, outputs or state unless unavoidable and explicitly protected.
- Provider and module versions constrained; dependency lock file committed.
- Format, validate, test, lint, security scan and plan review enforced.
- Replacements/deletions and database/data-loss risks reviewed.
- Tags/labels, owner, environment and cost-center conventions established.
- Budget alerts, billing visibility and cleanup verified.
- Drift, import, upgrade and disaster-recovery runbooks exercised.

## External references

- Terraform language: https://developer.hashicorp.com/terraform/language
- Providers: https://developer.hashicorp.com/terraform/language/providers
- Backends: https://developer.hashicorp.com/terraform/language/backend
- Modules: https://developer.hashicorp.com/terraform/language/modules
- AWS provider: https://registry.terraform.io/providers/hashicorp/aws/latest/docs
- AzureRM provider: https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs
- Google provider: https://registry.terraform.io/providers/hashicorp/google/latest/docs
- Terraform testing: https://developer.hashicorp.com/terraform/language/tests
