# Day 56 — Troubleshooting

## Learning Objective
Provider, dependency, replacement, state and authentication failures.

## Notes
- Learn the concept before syntax.
- Separate configuration, state, graph, provider and remote API behavior.
- Identify security, reliability, cost and maintainability implications.
- Compare alternatives and document trade-offs.

## Example
Start with the smallest working configuration, then refactor into a production-safe design.

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
Solve ten deliberately broken configurations from symptom to root cause.

## Break/Fix
1. Introduce one deliberate error.
2. Run formatting, validation and plan as appropriate.
3. Read the complete error before editing.
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
**Q1. What is the core idea of Troubleshooting?**  
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
- Relevant architecture/concept diagram updated.
