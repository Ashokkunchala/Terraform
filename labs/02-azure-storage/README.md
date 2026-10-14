# Lab 02 — Azure Resource Group and Storage Account

## Goal

Learn Azure's subscription/resource-group model and compare it with AWS accounts/regions and GCP projects. This starter README intentionally documents the lab before cloud resources are created; build the configuration only after verifying subscription permissions, resource naming, regional availability and current provider documentation.

## Prerequisites

- An Azure subscription you are authorized to use.
- Azure CLI authenticated to the intended tenant/subscription.
- Terraform CLI installed.
- A budget or cost alert; confirm the resource types and redundancy tier before creation.

Verify the target identity and subscription:

```bash
az account show --output table
az account list --output table
```

## Exercises

1. Create a separate Terraform root module for this lab.
2. Declare `hashicorp/azurerm` with an explicit tested version constraint and the required provider features block.
3. Create a resource group using a typed, validated location variable.
4. Create a storage account with a globally unique, Azure-compliant name; require HTTPS/TLS and choose a cost-appropriate redundancy option.
5. Add tags for environment, owner, and managed-by.
6. Output the resource group name and storage account name, not credentials or keys.
7. Run `terraform fmt`, `terraform init`, `terraform validate`, and inspect `terraform plan`.
8. Apply only after reviewing the plan. Verify via Azure CLI/portal.
9. Destroy the disposable lab and confirm that the resources were removed.

## Interview prompts

- What is the Azure scope hierarchy from tenant to resource?
- What is the difference between Azure RBAC and a resource's data-plane authorization?
- Why should storage keys not be exposed through Terraform outputs?
- What is the trade-off between locally stored state and a protected AzureRM backend?

## Safety

Storage can incur charges depending on capacity, operations, redundancy and data transfer. Do not use personal or production data. Never commit `terraform.tfstate`, local variables containing secrets, or storage keys.
