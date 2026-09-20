# Day 02 — Terraform CLI Workflow

## Objective
Become fluent with the core Terraform development loop.

## Core Workflow
Terraform's core CLI commands include init, validate, plan, apply and destroy. citeturn726687search4

```text
init → fmt → validate → plan → review → apply → inspect → destroy
```

## Lab
Use a local practice configuration and run:

```bash
terraform init
terraform fmt -recursive
terraform validate
terraform plan
terraform apply
terraform show
terraform state list
terraform output
terraform destroy
```

## Saved Plan Exercise

```bash
terraform plan -out=tfplan
terraform apply tfplan
```

Saved plans are useful in automation where the apply step should execute the plan that was reviewed. citeturn726687search7

## fmt vs validate
- `terraform fmt` rewrites configuration into canonical Terraform formatting. citeturn726687search9
- `terraform validate` checks syntax and internal consistency; it does not validate remote services. citeturn726687search3

## Break/Fix
1. Break HCL syntax; run fmt, then validate.
2. Run validate before initialization and explain the dependency.
3. Change configuration after a speculative plan and explain why CI needs a deliberate plan/apply workflow.

## Interview Q&A
**Q: Why run fmt in CI?**  
A: To enforce canonical formatting and prevent style drift.

**Q: Does validate test whether an AWS subnet actually exists?**  
A: No. It checks configuration correctness, not remote service behavior. citeturn726687search3

**Q: Why separate plan and apply in production CI?**  
A: Reviewers can inspect the intended change before an approved automation job applies it.

## Exit Criteria
- [ ] Use core CLI commands without copying a tutorial.
- [ ] Inspect state.
- [ ] Explain speculative vs saved plans.
- [ ] Explain fmt vs validate.
