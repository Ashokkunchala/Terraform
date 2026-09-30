#!/usr/bin/env bash
set -euo pipefail

terraform init
terraform fmt -recursive
terraform validate
terraform plan

echo "Review the plan above. Run 'terraform apply' explicitly when ready."
