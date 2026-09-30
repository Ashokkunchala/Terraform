# Project 00 — Terraform State Bootstrap

Creates the S3 bucket used for remote Terraform state.

## Run

```bash
terraform init
terraform fmt
terraform validate
terraform plan -var='bucket_name=YOUR-UNIQUE-BUCKET-NAME'
terraform apply -var='bucket_name=YOUR-UNIQUE-BUCKET-NAME'
terraform output backend_example
```

Copy the generated backend configuration into a real project, then initialize that project with `terraform init -migrate-state`.

The state bucket has versioning, public-access blocking, and server-side encryption. Native S3 locking is enabled in the generated backend example with `use_lockfile = true`.
