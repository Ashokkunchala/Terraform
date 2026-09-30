# Project 03 — Production EKS Platform

A production-oriented Amazon EKS reference project for learning and portfolio work.

## Architecture

```text
Internet
   |
AWS Load Balancer Controller / ALB
   |
EKS managed node groups (private subnets)
   +-- application namespace
   +-- ingress
   +-- metrics / observability
   |
ECR ---- container images
   |
RDS / Secrets Manager / CloudWatch
```

## Implementation goals

- VPC with public and private subnets across multiple AZs
- EKS control plane with private endpoint option
- Managed node groups in private subnets
- EKS access entries instead of legacy-only aws-auth management
- Cluster encryption with KMS
- OIDC / IRSA-ready IAM integration
- ECR repositories with scan-on-push and lifecycle policies
- AWS Load Balancer Controller integration
- Kubernetes namespaces, service accounts, deployment and service examples
- Cluster autoscaler/Karpenter integration documented as separate options
- CloudWatch observability integration
- Secrets Manager integration pattern
- Pod security, network policy and resource requests/limits examples
- CI validation and security scanning

## Build order

1. Network
2. EKS control plane
3. Managed node groups
4. IAM / access entries
5. OIDC and workload identity
6. ECR
7. AWS Load Balancer Controller
8. Application workload
9. Autoscaling
10. Observability
11. Security hardening
12. Disaster recovery and upgrade runbook

## Safety

EKS is a billable AWS service. Review `terraform plan` before applying and destroy the lab when finished.

Do not commit kubeconfigs, AWS credentials, Kubernetes secrets, Terraform state, or plan files.
