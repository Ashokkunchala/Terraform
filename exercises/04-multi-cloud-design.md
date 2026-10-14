# Exercise 04 — Multi-Cloud Design and Interview Drills

## Exercise A — Translate the architecture, not the syntax

Design a private object-storage use case in AWS, Azure and Google Cloud. Document:

- Administrative boundary (account/subscription/project).
- Identity used by Terraform and runtime workloads.
- Network and private-access options.
- Public access prevention/blocking.
- Encryption, versioning/retention and recovery.
- Audit visibility and cost controls.
- State backend, locking, access control and recovery.
- Apply and destroy permissions.

Do not force all providers into one module with identical arguments. Make a shared interface only for concepts whose semantics genuinely match.

## Exercise B — Root or module?

A company has development and production infrastructure in three clouds. Decide whether to use one root with many provider aliases, multiple roots with independent state, or a mixed design. Evaluate team ownership, blast radius, plan size, permissions, deployment timing and recovery. Record why the alternative approaches were rejected.

## Exercise C — Identity failure

A pull-request plan works, but deployment fails because the role or service identity cannot create a network. Write a diagnostic sequence covering the selected tenant/account/project, federation claims, trust relationship, effective permissions, organization policy and APIs.

## Exercise D — Destructive plan

A plan unexpectedly replaces a database after a provider update. Produce a no-apply incident checklist. Investigate versions, immutable attributes, address changes, import history, state, variables and the target environment. State who must approve the final plan.

## Exercise E — State incident

A state object has been overwritten or deleted. Explain how to stop concurrent writes, find an authoritative backup/version, assess lineage/serial and resource reality, restore carefully, and validate the next plan. Name the conditions under which manual state surgery would be inappropriate.

## Exercise F — Portability argument

An architect asks for 100% cloud-agnostic Terraform modules. Prepare a balanced answer: what can be standardized (labels, names, ownership metadata, outputs, pipeline steps) and what should remain provider-specific (networking, identity, managed services, policy, resilience and cost).

## Scoring

For each exercise, score 0–2 on technical accuracy, evidence/diagnostics, trade-offs, security, and operational recovery. Target at least 8/10 before moving forward.
