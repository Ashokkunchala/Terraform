# Terraform Capstone Runbook

Use this runbook for each executable project. Start with the cloud-free lab; do not start by deploying EKS or RDS.

## 0. Prerequisites

- Terraform version compatible with the root module's `required_version`.
- AWS CLI v2 and Docker for container projects.
- An AWS sandbox account with budget alerts and scoped permissions.
- A selected region (examples default to `us-east-1`).
- No committed credentials or plaintext secrets.

Confirm identity before every AWS project:

```bash
aws sts get-caller-identity
aws configure get region
terraform version
```

## 1. Local fundamentals

```bash
cd labs/00-local-basics
terraform init
terraform fmt -check
terraform validate
terraform test
terraform plan
```

Expected evidence: successful validation and test output; no AWS resources should be created by this lab.

## 2. S3 security lab

```bash
cd ../01-s3-static-data
cp terraform.tfvars.example terraform.tfvars 2>/dev/null || true
# Set bucket_name to a globally unique name in your untracked tfvars file.
terraform init
terraform fmt -check
terraform validate
terraform plan
```

Review encryption, versioning, and public-access blocking in the plan. Apply only after choosing a unique bucket name and confirming the target account. If the lab does not have an example tfvars file, create one locally with the required variable; do not commit it.

## 3. State bootstrap

```bash
cd ../../projects/00-state-bootstrap
terraform init
terraform validate
terraform plan -var='bucket_name=YOUR-GLOBALLY-UNIQUE-STATE-BUCKET'
```

Apply only after reviewing the plan. Record the backend example output. Before configuring a consuming root, confirm the bucket exists, versioning/encryption are enabled, access is restricted, and lockfile permissions are available. Never put state in a public bucket.

## 4. Static site

```bash
cd ../01-static-site
terraform init
terraform validate
terraform plan
```

Review CloudFront distribution creation, bucket policy and the bucket's deletion behavior. The example uses the default CloudFront certificate; a custom domain requires separate ACM/DNS setup. After apply, test the output URL and confirm direct public S3 access is blocked. This distribution can take several minutes to deploy.

## 5. ECS platform

```bash
cd ../02-ecs-platform
cp terraform.tfvars.example terraform.tfvars
terraform init
terraform fmt -check -recursive
terraform validate
terraform plan
```

Review NAT gateways, ALB, ECS tasks, ECR, RDS, backup retention and deletion protection. Push an image using the repository's image helper after authenticating Docker to ECR, then update the image input and apply a reviewed plan. Verify target health, task logs, scaling and rollback. Confirm whether the app actually uses the database; infrastructure provisioning alone does not prove application-level DB connectivity.

## 6. EKS platform

```bash
cd ../03-eks-platform
cp terraform.tfvars.example terraform.tfvars
terraform init
terraform fmt -check -recursive
terraform validate
terraform plan
```

EKS has meaningful control-plane, worker, NAT and load-balancer costs. Verify endpoint exposure, node subnets, access entries, IAM integration, add-on versions and Kubernetes provider requirements before apply. After provisioning, configure kube access, deploy the sample app, test service/ingress and resource limits, then destroy the disposable environment and verify load balancers and NAT resources are gone.

## Evidence checklist

- [ ] CLI version and AWS identity (do not publish account-sensitive details).
- [ ] Reviewed plan with unexpected replacements explained.
- [ ] Format, validate, test, lint and security scan results.
- [ ] Runtime health check and application log review.
- [ ] Failure/rollback or recovery exercise.
- [ ] Cost review and teardown verification.
- [ ] Short explanation of the architecture and trade-offs.

Do not paste state contents, credentials, kubeconfigs, unredacted plans, or secret values into tickets or commits.
