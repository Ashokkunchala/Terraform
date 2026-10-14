# Lab 03 — Google Cloud Project and Cloud Storage

## Goal

Learn the Google Cloud project boundary, IAM service accounts and Cloud Storage security controls. Compare project-scoped resources with AWS account and Azure subscription/resource-group boundaries.

## Prerequisites

- A Google Cloud project you are authorized to use with billing configured as required.
- Google Cloud CLI authenticated as a permitted user, or an approved service identity.
- Terraform CLI installed.
- A budget or cost alert and a cleanup plan.

Verify the active identity/project before running Terraform:

```bash
gcloud auth list
gcloud config get-value project
gcloud projects describe "$(gcloud config get-value project)"
```

## Exercises

1. Create a separate Terraform root module for this lab.
2. Declare `hashicorp/google` with a tested version constraint and explicit project/location variables.
3. Create a Cloud Storage bucket with a unique globally available name.
4. Enable uniform bucket-level access and public-access prevention for this private-data lab.
5. Choose location and lifecycle/versioning settings deliberately.
6. Use labels for environment, owner and managed-by where supported.
7. Output only non-secret identifiers.
8. Run `terraform fmt`, `terraform init`, `terraform validate`, and review `terraform plan`.
9. Apply in the sandbox, verify via `gcloud storage buckets describe`, then destroy and verify cleanup.

## Interview prompts

- What is the scope of a Google Cloud project?
- How do service accounts and IAM policy bindings work?
- What is the difference between project-level IAM and bucket-level access?
- What does uniform bucket-level access change?
- Why might a separate state object/project be appropriate for production?

## Safety

Cloud Storage cost depends on storage, operations, location, retrieval and network traffic. Never use personal/production data for exercises. Never commit service-account keys, state, secret variables or plan files. Prefer short-lived identity federation for automation rather than long-lived service-account key files.
