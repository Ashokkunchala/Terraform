# Hands-On Labs

Every lab should live under a separate directory so state and credentials cannot accidentally leak between exercises.

## Lab Standard

Each lab should contain:
- main.tf
- variables.tf
- outputs.tf
- locals.tf when useful
- versions.tf
- README.md
- tests/ when applicable
- .gitignore

## Safety
Use a sandbox AWS account, budgets and cleanup automation. Never commit credentials or state files.

## Lab Lifecycle
init → fmt → validate → plan → review → apply → inspect → test → destroy.
