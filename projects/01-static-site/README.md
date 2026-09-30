# Project 01 — Secure Static Website

A working private-S3 + CloudFront static website. The S3 bucket is not public; CloudFront accesses it through Origin Access Control and the distribution redirects viewers to HTTPS.

## Architecture

```text
Browser -> CloudFront -> Origin Access Control -> private S3
```

## Deploy

```bash
cd projects/01-static-site
terraform init
terraform fmt
terraform validate
terraform plan
terraform apply
terraform output cloudfront_url
```

The project uses the CloudFront-managed certificate, so it works without owning a domain. For a custom domain, extend it with ACM in `us-east-1` and Route 53 aliases.

## Security controls

- S3 public access is blocked
- S3 bucket policy grants read only to the CloudFront service principal through the distribution ARN
- S3 versioning is enabled
- CloudFront redirects HTTP viewers to HTTPS
- CloudFront Origin Access Control uses SigV4

## Cleanup

```bash
terraform destroy
```

`force_destroy` is enabled because this is a disposable learning project. Remove that setting for a production content bucket where accidental deletion must be prevented.
