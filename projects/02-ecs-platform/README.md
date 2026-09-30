# Project 02 — Production ECS/Fargate Platform

A complete reference deployment for an AWS web application using ECS/Fargate, ALB, private subnets, ECR, RDS MySQL, Secrets Manager, CloudWatch Logs, and CPU/memory autoscaling.

## Architecture

```text
                    Internet
                       |
                 Public ALB / TLS
                       |
              +--------+--------+
              |                 |
        Private subnet    Private subnet
              |                 |
          ECS task          ECS task
              +--------+--------+
                       |
                 Private RDS MySQL
                       |
                Managed secret
```

## Included

- Two-AZ VPC
- Public and private subnets
- Internet gateway
- NAT gateway(s), with a single-NAT cost-saving option
- ALB security group and ECS task security group
- Optional ACM certificate with HTTP-to-HTTPS redirect
- ECS/Fargate cluster with Container Insights
- CloudWatch log group
- ECR repository with scan-on-push and lifecycle retention
- ECS deployment circuit breaker with rollback
- CPU and memory target-tracking autoscaling
- Private encrypted RDS MySQL
- RDS-managed master password in Secrets Manager
- Least-privilege task-role access to the RDS secret

## First deployment

```bash
cd projects/02-ecs-platform
cp terraform.tfvars.example terraform.tfvars
terraform init
terraform fmt -recursive
terraform validate
terraform plan
terraform apply
terraform output load_balancer_url
```

The default image is public nginx so the platform can be tested before building an application image. After creating your application image, push it to the generated ECR repository and set `container_image` to that URI.

## Production hardening

For production, use one NAT gateway per AZ, an ACM certificate, a custom Route 53 record, tighter IAM policies, alarms, WAF, CloudFront where appropriate, and a remote S3 backend with `use_lockfile = true`.

## Cleanup

```bash
terraform destroy
```

Do not destroy a production database without an approved recovery and retention procedure. The `prod` environment intentionally enables RDS deletion protection and Multi-AZ.
