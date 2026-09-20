# Day 01 — Terraform Foundations

## Objective
Build the correct mental model before memorizing HCL.

## Key Terms
| Term | Meaning |
|---|---|
| IaC | Infrastructure managed through code |
| Configuration | Terraform .tf files describing desired behavior |
| Provider | Plugin translating Terraform operations to an external API |
| Resource | Managed infrastructure object |
| State | Terraform's record of managed-object information |
| Plan | Proposed actions |
| Apply | Executes changes |
| Module | Reusable Terraform configuration |

## Mental Model

```text
Configuration + State + Provider Data
                │
                ▼
        Dependency Graph
                │
                ▼
              Plan
                │
                ▼
             Apply
                │
                ▼
      Real Infrastructure
                │
                ▼
              State
```

## Lab
Create `labs/day-01/main.tf`:

```hcl
terraform {
  required_version = ">= 1.6, < 2.0"
}

variable "student_name" {
  type        = string
  description = "Name displayed by the lab."
}

output "message" {
  value = "Hello, ${var.student_name}!"
}
```

Run:

```bash
terraform init
terraform fmt
terraform validate
terraform plan -var='student_name=terraform-student'
terraform apply -var='student_name=terraform-student'
```

## Break/Fix
1. Pass a number to `student_name` and inspect the type error.
2. Remove a closing brace and compare formatter/validation behavior.
3. Change the output expression and predict the result before running it.

## Interview Q&A
**Q: What does declarative mean?**  
A: You describe desired state rather than coding every API operation. Terraform calculates actions to converge toward that state.

**Q: Why is state needed?**  
A: It maps Terraform addresses to managed objects and supports change calculation.

**Q: Plan vs apply?**  
A: Plan proposes changes; apply executes them. Apply normally creates a plan if one is not supplied. citeturn726687search7

## Exit Criteria
- [ ] Explain the Terraform graph without notes.
- [ ] Create and validate a configuration from scratch.
- [ ] Explain why state exists.
- [ ] Complete all break/fix tasks.
