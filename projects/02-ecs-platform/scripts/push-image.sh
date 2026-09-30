#!/usr/bin/env bash
set -euo pipefail

REGION="${AWS_REGION:-us-east-1}"
REPO_URL="$(terraform output -raw ecr_repository_url)"
ACCOUNT="$(aws sts get-caller-identity --query Account --output text)"
REGISTRY="${ACCOUNT}.dkr.ecr.${REGION}.amazonaws.com"

aws ecr get-login-password --region "$REGION" | docker login --username AWS --password-stdin "$REGISTRY"
docker build -t "${REPO_URL}:v1" ./app
docker push "${REPO_URL}:v1"

echo "Set container_image=${REPO_URL}:v1 in terraform.tfvars and run terraform apply."
