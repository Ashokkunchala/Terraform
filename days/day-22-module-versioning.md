# Day 22 — Module Versioning

## Learning Objective
Git sources, registry modules, semantic versioning and upgrades.

## Notes
- Learn the concept first, then syntax.
- Understand configuration, state, graph, provider behavior and remote API behavior separately.
- Identify security, reliability, cost and maintainability implications.
- Compare alternatives and document the trade-off.

## Example
Start with the smallest working configuration. Then refactor it into a reusable or production-safe form.

```hcl
terraform {
  required_version = ">= 1.6, < 2.0"
}

variable "environment" {
  type    = string
  default = "dev"
}

locals {
  common_tags = {
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
}
```

## Practical Lab
Version a module and consume a pinned release.

## Break/Fix
1. Introduce one deliberate error.
2. Run formatting/validation/plan as appropriate.
3. Read the error carefully before editing code.
4. Identify the root cause.
5. Re-run the plan and explain the difference.

## Production Checklist
- [ ] Version constraints
- [ ] Naming and tagging
- [ ] Least privilege
- [ ] No hard-coded secrets
- [ ] State safety
- [ ] Dependency clarity
- [ ] Tests or validation
- [ ] Cost considered
- [ ] Failure/recovery considered

## Interview Q&A
**Q1. What is the core concept of Module Versioning?**  
A: Define it, explain why it exists, show a small example, and describe one production trade-off.

**Q2. What would you verify before production?**  
A: State boundaries, IAM, secrets, dependencies, replacement behavior, observability, cost, testing and recovery.

**Q3. Terraform does not behave as expected. What do you inspect?**  
A: Configuration, resource address, provider configuration, current state, data sources, dependency graph and the complete plan.

## Deliverable
- Working configuration committed to Git.
- Plan understood.
- One failure diagnosed.
- Interview questions answered aloud.
- Relevant diagram updated.
