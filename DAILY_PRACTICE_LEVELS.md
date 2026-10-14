# Daily Terraform Practice — Level-Based Learning

## Purpose

Use this practice system alongside the lessons in `days/`. It is deliberately **level-based, not a fixed 30-day sprint**. Move forward when you can explain and perform the current level independently; repeat a lesson or adjust the plan during the first week if needed.

## Daily session structure (60–90 minutes)

1. **Recall — 5 minutes:** explain yesterday's topic without opening notes.
2. **Learn — 10–15 minutes:** read the matching `days/day-XX-*.md` lesson and write three key ideas.
3. **Build — 20–30 minutes:** create or modify the smallest useful configuration.
4. **Predict — 5–10 minutes:** write what you expect `terraform plan` to create, change, replace, or destroy.
5. **Validate — 10 minutes:** run format, init, validate and tests appropriate to that root.
6. **Break/fix — 10 minutes:** introduce one safe, reversible fault and diagnose it from the error.
7. **Interview — 5–10 minutes:** answer two or three questions aloud.
8. **Log — 5 minutes:** record evidence, score, unresolved questions and cleanup.

If you have less time, complete Recall → Build → Validate → Log. Do not skip reviewing a plan before applying.

## Learning levels

### Level 0 — Setup and safe workflow

**Goal:** work safely in a clean clone before provisioning anything.

Practice:
- Check Terraform and Git versions.
- Navigate to the correct lab root and inspect its files.
- Run `terraform fmt -check -recursive`, `terraform init -backend=false`, and `terraform validate` where appropriate.
- Explain why state, plan files, credentials and secret tfvars must not be committed.
- Read the root `.gitignore` and identify ignored artifacts.

**Pass gate:** explain each command, locate the correct root, and show that no cloud resources are needed for the local basics lab.

### Level 1 — HCL and Terraform fundamentals

**Goal:** write simple configurations without copying line by line.

Practice:
- Variables with types/validation, locals, outputs, expressions and collections.
- Resources vs data sources; providers vs modules.
- Dependency references and the dependency graph.
- `count` vs `for_each`; implicit dependencies vs justified `depends_on`.
- Predict plan changes before running the plan.

**Pass gate:** write a small example, explain its values and graph, validate it, and diagnose one syntax or type error.

### Level 2 — State, lifecycle and modules

**Goal:** explain how Terraform tracks real objects and changes safely.

Practice:
- Inspect state only in a disposable lab; never publish it.
- Explain state locking, versioning, backup and recovery.
- Use module inputs/outputs and a clear contract.
- Practice import and `moved` blocks in a safe example.
- Diagnose drift and an unexpected replacement plan.

**Pass gate:** explain how to investigate an unexpected destroy/replace without blindly applying or manually deleting state.

### Level 3 — Cloud implementation

**Goal:** build and verify small, isolated resources in each cloud.

Practice in this order:
1. AWS S3 lab: encryption, public-access blocking, versioning, permissions and cleanup.
2. Azure runbook: resource group, storage account, identity/RBAC, naming and location.
3. GCP runbook: project, Cloud Storage bucket, service account/IAM, location and access prevention.

For each cloud:
- Authenticate using the provider's recommended identity method.
- Use a sandbox and cost controls.
- Run format/init/validate/plan; review every proposed change.
- Apply only when the lab and budget are understood.
- Verify via Terraform output and cloud CLI/console.
- Destroy disposable resources and confirm cleanup.

**Pass gate:** explain the identity scope, resource hierarchy, storage access controls and cost/cleanup risks for the cloud you practiced.

### Level 4 — Production engineering

**Goal:** prepare changes that are safe to review and operate.

Practice:
- Remote state isolation, locking, recovery and least-privilege access.
- CI format/validate/test/security checks and reviewed plan artifacts.
- Short-lived CI identity federation instead of long-lived credentials where supported.
- Secrets handling, provider lock files and controlled upgrades.
- Tags/labels, cost review, observability, backup and disaster recovery.
- Review a pull request and list the top risks before approving it.

**Pass gate:** produce a review checklist and explain how to stop an unsafe plan from reaching apply.

### Level 5 — Interview and design

**Goal:** explain trade-offs and troubleshoot unfamiliar failures.

Practice one scenario per session:
- Terraform wants to replace a database unexpectedly.
- State lock remains after an interrupted run.
- A manual console change creates drift.
- CI works locally but cannot authenticate.
- A storage bucket becomes publicly accessible.
- Two cloud environments share an unsafe state boundary.
- Provider upgrade changes a resource plan.
- Apply partially fails.

Use this answer pattern: **symptom → evidence → likely cause → safe fix → prevention → recovery/rollback**.

**Pass gate:** answer without notes, state assumptions, and explain why at least one alternative is worse.

## Weekly adjustment rule

At the end of the first seven practice sessions, review your log. Spend the next sessions on the weakest two areas instead of automatically moving to harder topics. Continue adjusting weekly. A session can take multiple days; do not mark it complete just because you read the lesson.

## Daily practice log template

Copy this section into a private local file such as `practice-log.md`. Keep credentials, state, secret values and sensitive plans out of the log.

```markdown
## Date:
- Level / lesson:
- Time spent:
- What I can explain from memory:
- What I built or changed:
- Predicted plan:
- Actual validation/test result:
- Break/fix symptom:
- Root cause and fix:
- Security / cost / availability concern:
- Interview questions answered:
- Cleanup verified (if applicable):
- Score (0–2 each): understanding __ / build __ / validation __ / troubleshooting __ / explanation __ = __/10
- Questions still unclear:
- Next session:
```

### Scoring guide

- **0:** cannot do it yet, or only copied steps.
- **1:** can do it with notes or hints.
- **2:** can explain and perform it independently.

A topic is ready to advance at **8/10 or higher**, with no zero for safety/cleanup when cloud resources were involved. Otherwise repeat the relevant exercise, write down the blocker, and retry.

## Daily completion checklist

- [ ] Explained the concept in my own words.
- [ ] Built or changed something myself.
- [ ] Predicted the plan before inspecting it.
- [ ] Ran the relevant validation/tests.
- [ ] Diagnosed one controlled failure or explained a real error.
- [ ] Answered interview questions aloud.
- [ ] Recorded evidence and unresolved questions.
- [ ] Verified cleanup for any disposable cloud resources.

## Safety rules

- Never apply an unreviewed plan or run experiments against production.
- Never commit credentials, state, plan files, secret tfvars, kubeconfigs or sensitive logs.
- Confirm the active account/subscription/project before cloud operations.
- Cloud services may incur charges; verify resource deletion and retained data after a lab.
- A passing CI check is not proof that a cloud deployment works at runtime.
