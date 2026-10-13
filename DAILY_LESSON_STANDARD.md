# Daily Lesson Acceptance Standard

Every daily lesson in `days/` should be completed using this checklist. A topic is not complete merely because its concept summary exists.

## Required lesson sections

1. **Learning objectives** — three to five observable outcomes.
2. **Prerequisites** — prior lesson, tools, and account requirements.
3. **Concepts** — explain the mechanism and the common misconceptions.
4. **Hands-on build** — exact working directory, complete relevant configuration or a precise file diff, and commands in order.
5. **Expected result** — what successful output/plan should show; distinguish illustrative output from output verified in CI.
6. **Plan reasoning** — predict creates, updates, replacements, destroys, unknown values, and dependencies before running the command.
7. **Break/fix lab** — a safe, deliberate failure, expected symptom, diagnosis steps, and the fix.
8. **Production scenario** — security, state, availability, cost, rollback, and ownership trade-offs relevant to the topic.
9. **Interview practice** — at least five questions, including one scenario question, with concise answer notes.
10. **Exit criteria** — a concrete deliverable and a self-assessment score.

## Required validation

For a Terraform root module:

```bash
terraform fmt -check -recursive
terraform init -backend=false
terraform validate
```

Run `terraform test` where tests exist. Run TFLint and Checkov when applicable. AWS deployment steps must require a reviewed plan and a sandbox account. Never make a destructive exercise depend on production infrastructure.

## Evidence to save locally

- The plan reasoning and final result.
- The failure symptom and root cause.
- Security and cost considerations.
- Answers to interview questions.
- Cleanup verification.

Do not commit credentials, Terraform state, secret variable files, kubeconfigs, or unredacted plan artifacts.

## Repository-wide quality bar

- Commands must match the actual files and required variables in the repository.
- Paths must be correct from a clean clone.
- Explain when a step creates billable resources.
- A CI pass is configuration validation, not proof of successful cloud deployment.
- Fix duplicated, contradictory or stale instructions when discovered.
