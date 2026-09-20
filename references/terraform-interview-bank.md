# Terraform Interview Bank

## Fundamentals
### 1. What is Terraform?
A declarative infrastructure-as-code tool. You describe desired infrastructure and Terraform calculates actions to converge toward it.

### 2. What happens during plan?
Terraform evaluates configuration, state and relevant provider information to create a proposed change set.

### 3. Why does Terraform need state?
State maps Terraform-managed resource addresses to real infrastructure objects and supports change calculation.

### 4. Why use remote state?
Teams need shared state storage and a concurrency strategy. Backends provide state storage and may provide locking. citeturn726687search1turn726687search2

## Intermediate
### 5. count vs for_each
count uses numeric indexes; for_each uses stable keys.

### 6. Resource vs data source
A resource manages an object. A data source reads information about an existing object or external fact.

### 7. Implicit dependency
Created automatically when one expression references another resource/module value.

### 8. When should depends_on be used?
When a real dependency exists but is not represented by an expression. Avoid unnecessary explicit dependencies.

### 9. What makes a good module?
Clear responsibility, explicit inputs/outputs, validation, versioning, minimal hidden behavior, documentation and tests.

## Advanced
### 10. How do you protect state?
Use restricted backend access, encryption, versioning, least privilege, limited production access and tested recovery procedures. S3 guidance recommends bucket versioning for recovery. citeturn726687search0

### 11. How do you handle drift?
Detect it, determine whether the out-of-band change is intentional, update configuration or reconcile infrastructure, then re-plan.

### 12. How do you rename a resource safely?
Use a moved block or controlled state move so Terraform recognizes address migration.

### 13. What should CI do before apply?
Formatting, validation, security/lint checks, tests, plan, policy/cost checks as needed, review/approval, then apply of the intended plan.

### 14. What happens if apply fails halfway?
Successful changes are recorded in state; diagnose the failure, inspect the next plan, fix the root cause and retry.

## Scenario Questions
1. Production plan wants to replace a database. What do you inspect?
2. A rename causes destroy/create. How do you avoid unnecessary replacement?
3. Two engineers run apply simultaneously. What should protect concurrent state writes?
4. A security group was changed manually. How do you investigate?
5. A secret appears in state. What are the implications and remediation steps?
6. One module deploys to two regions. How do provider aliases fit?
7. Dev and prod need different permissions. How should CI identities/providers be structured?
8. Import succeeded but plan still shows changes. Why?
9. A module accepts unrestricted maps and becomes hard to maintain. How do you improve its contract?
10. CI plan passes but apply fails. What environmental differences could explain it?

## Answer Pattern
**Definition → Why → Example → Trade-off → Production consideration**
