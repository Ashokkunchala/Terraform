# Day 04 — Providers

**Build:** configure the AWS provider with an explicit version constraint and region; run `terraform init` and inspect `.terraform.lock.hcl`.

**Break/fix:** alter the provider constraint and observe dependency resolution.

**Production:** constrain provider versions and commit the lock file.

**Interview:** what `required_providers` controls, why lock files matter, and when aliases are needed.

**Exit:** configure one provider and explain version selection.