# CI and Infrastructure Security

## What the workflow checks

The workflow runs on pull requests, pushes to `main`, and manual dispatch:

1. `terraform fmt -check -recursive`
2. `terraform init -backend=false` and `terraform validate` for each listed executable root.
3. `terraform test` for the cloud-free local lab.
4. Checkov scans Terraform and Kubernetes manifests.

## What a green build means

It means the listed checks completed successfully for that commit. It does not validate credentials in a real AWS account, quota availability, runtime connectivity, application behavior, costs, or successful teardown.

The current Checkov step uses `--soft-fail` intentionally while the learning repository establishes a baseline. Review the job logs and fix applicable findings. Do not interpret a successful soft-fail job as a clean security report. Once findings are triaged and fixed, remove soft-fail so new findings can block changes.

## Local security scan

Install Checkov in a virtual environment or isolated Python environment:

```bash
python -m venv .venv
# Linux/macOS: source .venv/bin/activate
# Windows PowerShell: .venv\Scripts\Activate.ps1
python -m pip install 'checkov>=3,<4'
checkov --directory . --framework terraform kubernetes
```

Use the current upstream installation guidance if your Python version or platform needs a different installation method.

## Remediation rules

- Prefer fixing the infrastructure rather than suppressing a control.
- If a finding is not applicable, document the resource, control ID, rationale, compensating control, and review date next to the suppression.
- Never suppress an entire framework or directory just to get a green build.
- Keep provider constraints and lock files under review; upgrade deliberately and rerun validation.
- Avoid secrets in Terraform variables or committed tfvars. Marking an output sensitive hides it from normal CLI display but does not remove it from state.
- Review IAM trust policies separately from permission policies.
- Validate ingress and egress paths across ALB, task/pod, and database security groups.
- Treat public endpoints and deletion-protection changes as explicit review items.
