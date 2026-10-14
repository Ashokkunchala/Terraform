# Multi-Cloud Terraform Interview Bank

Use these as oral practice prompts. A strong answer defines the concept, gives a realistic example, explains a trade-off, and names the production safeguard.

## Fundamentals

### 1. Is Terraform multi-cloud?
Yes. Terraform uses provider plugins to manage resources through different provider APIs. The same Terraform language can coordinate multiple clouds, but each provider exposes cloud-specific resource schemas and behaviors.

### 2. What is the difference between a provider and a module?
A provider is a plugin that implements resource/data-source types and talks to an API. A module is a collection of Terraform configuration used as a unit of composition and reuse.

### 3. Can AWS, Azure and Google Cloud resources be in one configuration?
Technically yes, with multiple provider configurations. Operationally, consider separate state boundaries and pipelines where team ownership, credentials, lifecycle, failure modes or blast radius differ.

### 4. What is the difference between a resource and a data source?
A resource declares an object Terraform manages. A data source reads information about an existing object or external fact; it does not ordinarily manage the object's lifecycle.

### 5. Why is state important?
State maps resource addresses to real objects and supports planning, dependency tracking and refresh behavior. State can contain sensitive values, so access and recovery controls matter.

### 6. What do init, validate, plan and apply do?
`init` prepares the working directory and provider/module dependencies; `validate` checks configuration consistency; `plan` proposes changes; `apply` executes an approved set of changes. Validate alone does not prove cloud permissions, API availability or runtime health.

## State and environments

### 7. How do you design state for dev/test/prod?
Use state boundaries aligned to blast radius, permissions, ownership and deployment lifecycle. Commonly each environment has a separate root/backend key or state object and restricted identity. Weigh duplication against isolation; workspaces alone are not a full security boundary.

### 8. What is a state lock?
A coordination mechanism intended to prevent concurrent operations from corrupting shared state. Confirm the chosen backend supports locking and understand its recovery procedure before manually removing a lock.

### 9. How do you recover from accidental state deletion?
Stop writes, restrict further changes, locate a trusted versioned/backup copy, validate its lineage/serial and environment, restore following the backend-specific runbook, then run a plan. Never overwrite production state casually.

### 10. What is drift?
A difference between declared configuration/state and real infrastructure, often caused by out-of-band changes. Investigate intent and impact; update code or reconcile the environment, then inspect a plan before applying.

### 11. How do you import a resource?
Declare the desired resource configuration and use an import block or the supported CLI workflow to bind the existing object to a Terraform address. Then inspect plan output and reconcile configuration; import is not equivalent to generating a safe complete configuration automatically.

## Provider and identity design

### 12. What are provider aliases?
Named configurations of the same provider, often used for different regions, accounts, subscriptions or projects. Child modules should receive providers deliberately; avoid relying on ambiguous defaults.

### 13. How should CI authenticate to multiple clouds?
Prefer each cloud's supported short-lived workload federation/OIDC mechanism, scoped to a repository/environment identity, over long-lived static credentials. Restrict the resulting role/service identity to only the required actions and resources.

### 14. Why can't a universal network module hide all cloud differences?
VPCs, VNets and Google VPC networks differ in scope, routing, subnet models, firewall behavior and resource dependencies. Over-abstraction creates misleading defaults and weakens provider-specific controls. Reuse contracts and patterns, but preserve meaningful differences.

### 15. How do you manage provider versions?
Declare tested version constraints in `required_providers`, commit the dependency lock file, upgrade deliberately, review changelogs and plan changes in non-production first. Avoid unconstrained upgrades during production runs.

## Cloud comparison scenarios

### 16. Compare AWS, Azure and GCP identity boundaries.
Discuss AWS roles/policies and STS; Azure Entra ID identities and RBAC scopes; Google service accounts and IAM policy bindings. Explain both who may assume/act as an identity and which permissions the identity has.

### 17. Compare object storage security.
Explain public access prevention/blocking, identity-based access, encryption, versioning/retention, logging and lifecycle policies. Call out each provider's distinct controls instead of pretending the resource arguments are interchangeable.

### 18. A team wants the same application in three clouds. What is your design?
Clarify portability requirements first. Keep the application/container and observability practices portable where realistic. Use provider-specific infrastructure modules and isolated state. Standardize tagging, naming, outputs and CI conventions only where concepts genuinely align. Compare the cost of portability against additional operational complexity.

### 19. A plan unexpectedly destroys a database. What do you do?
Do not apply. Check address/identity changes, immutable fields, provider/version changes, workspace/backend/account/project, variable files, imports and state. Preserve evidence, correct the root cause, plan again and require human review for destructive production changes.

### 20. A pull request plan passes but apply fails with AccessDenied.
Validate the CI identity and target account/subscription/project, trust/federation policy, resource scope, API enablement, permissions boundaries and any provider-specific prerequisites. Validation is configuration-oriented and usually does not prove the apply identity can complete the API calls.

### 21. When would you separate roots instead of one giant root?
When resources have different owners, lifecycles, permission scopes, change frequency, state risk, regions/accounts, recovery needs or approval processes. Accept small amounts of explicit wiring to reduce the blast radius.

### 22. What makes a module production-ready?
A clear responsibility and versioned interface; typed/validated inputs; meaningful outputs; minimal hidden provider behavior; security-conscious defaults; examples/tests; supported versions; upgrade notes; and a deprecation/migration plan.

## Operational troubleshooting drills

For each scenario, narrate your investigation before changing code.

1. Provider authentication works locally but fails in CI.
2. The wrong cloud account/subscription/project is targeted.
3. A resource is recreated after its Terraform address is renamed.
4. Two users attempt to apply the same remote state.
5. An imported resource immediately shows unexpected updates.
6. A provider upgrade changes a computed attribute or replacement behavior.
7. A secret is found in the Terraform state.
8. A bucket or storage account is unexpectedly public.
9. A module's `for_each` key changes and causes resource replacement.
10. A destroy leaves retained data or external dependencies behind.

## Suggested answer framework

- **Context:** What environment and failure are involved?
- **Evidence:** What do plan, state metadata, provider identity and logs show?
- **Root cause:** Separate configuration, state, provider, IAM, API and runtime possibilities.
- **Fix:** Small, reversible correction and a new plan.
- **Prevention:** Test, policy, least privilege, state recovery and monitoring.

## Hands-on rubric

Score each area from 0 to 2: 0 = cannot explain; 1 = can explain with notes; 2 = can explain and demonstrate.

- Terraform lifecycle and state.
- Typed module interface.
- Provider alias / identity.
- AWS/Azure/GCP architecture differences.
- Remote-state security and recovery.
- CI validation and approved apply.
- Drift/import/upgrade diagnosis.
- Cost/security/reliability trade-offs.

Target: 13/16 or higher, with no zero in state safety, identity or destructive-change review.
