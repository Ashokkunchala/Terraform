# Terraform CLI Cheat Sheet

The core workflow is init → validate → plan → apply → destroy. citeturn726687search4

## Daily
```bash
terraform init
terraform fmt -recursive
terraform validate
terraform plan
terraform plan -out=tfplan
terraform apply
terraform apply tfplan
terraform destroy
```

## Inspection
```bash
terraform show
terraform state list
terraform state show <address>
terraform output
terraform providers
terraform graph
terraform console
```

## State
```bash
terraform state mv OLD NEW
terraform state rm ADDRESS
terraform state pull
terraform state push STATEFILE
terraform force-unlock LOCK_ID
```
State push can overwrite remote state and belongs in controlled recovery procedures. citeturn726687search1

## Testing
```bash
terraform test
terraform test -filter=tests/example.tftest.hcl
```
Native Terraform tests can create real infrastructure, so cleanup matters. citeturn726687search6

## Debugging
```bash
TF_LOG=INFO terraform plan
TF_LOG=DEBUG terraform plan
terraform -help
```
Avoid leaking credentials or secrets into logs.
