# Contributing

1. Run `terraform fmt -check -recursive`.
2. Validate each changed lab or module with `terraform init -backend=false` and `terraform validate`.
3. Do not commit state, plan files, credentials, or secrets.
4. Keep modules focused with explicit inputs and outputs.
5. Explain breaking changes in pull requests.
6. Prefer small, reviewable commits.
