# Lab 01 — Secure S3 Foundation

This lab demonstrates provider configuration, typed variables, default tags, S3 versioning, and public-access blocking.

Create an untracked `terraform.tfvars`:

```hcl
bucket_name = "replace-with-a-globally-unique-name"
aws_region  = "us-east-1"
```

Run:

```bash
aws sts get-caller-identity
terraform init
terraform fmt
terraform validate
terraform plan
terraform apply
terraform destroy
```

Never commit credentials, state, plan files, or secret values.
